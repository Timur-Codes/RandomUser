//
//  MockUsersStorage.swift
//  RandomUsername
//

import Foundation

final class MockUsersStorage: UsersStorageProtocol {
    private(set) var storedUsers: [RandomUser] = []
    private(set) var storedNextPage: Int = .USERS_STARTING_PAGE
    private(set) var deletedUserIDs: Set<String> = []

    init(
        storedUsers: [RandomUser] = [],
        storedNextPage: Int = .USERS_STARTING_PAGE,
        deletedUserIDs: Set<String> = []
    ) {
        self.storedUsers = storedUsers
        self.storedNextPage = storedNextPage
        self.deletedUserIDs = deletedUserIDs
    }

    func getUsers() -> [RandomUser] {
        storedUsers
    }

    func saveUsers(_ users: [RandomUser]) {
        storedUsers = users
    }

    func getNextPage() -> Int {
        storedNextPage
    }

    func saveNextPage(_ page: Int) {
        storedNextPage = page
    }

    func getDeletedUserIDs() -> Set<String> {
        deletedUserIDs
    }

    func addDeletedUserID(_ id: String) {
        deletedUserIDs.insert(id)
    }
}
