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
    var searchText = ""

    var filteredUsers: [RandomUser] {
        guard !trimmedSearchText.isEmpty else {
            return users
        }

        return users.filter { $0.matches(searchText: trimmedSearchText) }
    }

    var showsEmptySearchResults: Bool {
        filteredUsers.isEmpty && !trimmedSearchText.isEmpty
    }

    private var trimmedSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var nextPage = Int.USERS_STARTING_PAGE
    private var deletedUserIDs: Set<String>

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

    // Deleted users will be sorted out from newly fetched users
    private func fetchUsers(page: Int) async throws -> [RandomUser] {
        let fetchedUsers = try await usersClient.fetchUsers(results: .USERS_FETCHING_LIMIT, page: page)
        
        // For example: 40 users - 2 deletedIds = 38 users (if those 2 ids appear in the new fetched list)
        return fetchedUsers.excludingUsers(withIDs: deletedUserIDs)
    }

    private func persistUsers() {
        usersStorage.saveUsers(users)
        usersStorage.saveNextPage(nextPage)
    }
}
