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

    private let usersClient: UsersServiceProtocol
    private let usersStorage: UsersStorageProtocol

    init(
        usersClient: UsersServiceProtocol,
        usersStorage: UsersStorageProtocol
    ) {
        self.usersClient = usersClient
        self.usersStorage = usersStorage
    }

    func loadUsersIfNeeded() async {
        guard viewState != .loaded else { return }

        let storedUsers = usersStorage.getUsers()

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
        
        // When we're at the last item in the list, then it should fetch the next 40 items
        // Otherwise don't fetch them
        guard currentUser.uuid == filteredUsers.last?.uuid else { return }

        isLoadingMore = true

        do {
            let fetchedUsers = try await fetchUsers(page: nextPage)
            users = users.appendingUniqueUsers(fetchedUsers)
            nextPage += 1
            persistUsers()
            isLoadingMore = false
        } catch {
            print("[UsersListViewModel] Failed to load more users: \(error)")
            isLoadingMore = false
        }
    }

    private func fetchUsers(page: Int) async throws -> [RandomUser] {
        try await usersClient.fetchUsers(results: .USERS_FETCHING_LIMIT, page: page)
    }

    private func persistUsers() {
        usersStorage.saveUsers(users)
        usersStorage.saveNextPage(nextPage)
    }
}
