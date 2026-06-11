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

    private let usersClient: UsersServiceProtocol

    init(usersClient: UsersServiceProtocol) {
        self.usersClient = usersClient
    }

    func loadUsersIfNeeded() async {
        guard viewState != .loaded else { return }
        await loadUsers()
    }

    func loadUsers() async {
        viewState = .loading

        do {
            users = try await usersClient.fetchUsers(results: .USERS_FETCHING_LIMIT)
            viewState = .loaded
        } catch {
            print("[UsersListViewModel] Failed to load users: \(error)")
            viewState = .error(error.localizedDescription)
        }
    }
}
