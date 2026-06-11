//
//  UsersListViewModel.swift
//  RandomUsername
//

import Foundation

@MainActor
@Observable
final class UsersListViewModel {
    enum ViewState: Equatable {
        case loading
        case loaded
        case error(String)
    }

    private(set) var users: [RandomUser] = []
    private(set) var viewState: ViewState = .loading
    private(set) var isLoadingMore = false
    private(set) var searchText = ""
    private(set) var appliedSearchText = ""

    var filteredUsers: [RandomUser] {
        guard !appliedSearchText.isEmpty else {
            return users
        }

        return users.filter { $0.matches(searchText: appliedSearchText) }
    }

    var showsEmptySearchResults: Bool {
        filteredUsers.isEmpty && !appliedSearchText.isEmpty
    }

    private var nextPage = Int.USERS_STARTING_PAGE
    private var deletedUserIDs: Set<String>
    private var searchTask: Task<Void, Never>?

    private let usersClient: UsersServiceProtocol
    private let usersStorage: UsersStorageProtocol

    init(
        usersClient: UsersServiceProtocol,
        usersStorage: UsersStorageProtocol
    ) {
        self.usersClient = usersClient
        self.usersStorage = usersStorage
        self.deletedUserIDs = usersStorage.getDeletedUserIDs()
    }

    func setSearchText(_ text: String) {
        searchText = text
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(Int.SEARCH_DEBOUNCE_MILLISECONDS))
            guard !Task.isCancelled else { return }

            appliedSearchText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func loadUsersIfNeeded() async {
        guard viewState != .loaded else { return }

        let storedUsers = usersStorage.getUsers().excludingUsers(withIDs: deletedUserIDs)

        guard storedUsers.isEmpty else {
            users = storedUsers
            nextPage = usersStorage.getNextPage()
            viewState = .loaded
            return
        }

        await loadUsers()
    }

    func loadUsers() async {
        viewState = .loading
        nextPage = .USERS_STARTING_PAGE

        do {
            users = try await fetchUsers(page: nextPage)
            nextPage += 1
            persistUsers()
            viewState = .loaded
        } catch {
            print("[UsersListViewModel] Failed to load users: \(error)")
            viewState = .error(error.localizedDescription)
        }
    }

    func loadMoreUsersIfNeeded(currentUser: RandomUser) async {
        guard viewState == .loaded else { return }
        guard !isLoadingMore else { return }
        guard currentUser.uuid == filteredUsers.last?.uuid else { return }

        isLoadingMore = true

        do {
            let fetchedUsers = try await fetchUsers(page: nextPage)
            users = users.appendingUniqueUsers(fetchedUsers, excluding: deletedUserIDs)
            nextPage += 1
            persistUsers()
            isLoadingMore = false
        } catch {
            print("[UsersListViewModel] Failed to load more users: \(error)")
            isLoadingMore = false
        }
    }

    func deleteUser(_ user: RandomUser) {
        users.removeAll { $0.uuid == user.uuid }
        deletedUserIDs.insert(user.uuid)
        usersStorage.addDeletedUserID(user.uuid)
        usersStorage.saveUsers(users)
    }

    private func fetchUsers(page: Int) async throws -> [RandomUser] {
        let fetchedUsers = try await usersClient.fetchUsers(results: .USERS_FETCHING_LIMIT, page: page)
        return fetchedUsers.excludingUsers(withIDs: deletedUserIDs)
    }

    private func persistUsers() {
        usersStorage.saveUsers(users)
        usersStorage.saveNextPage(nextPage)
    }
}
