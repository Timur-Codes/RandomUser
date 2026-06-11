//
//  MockUsersStorage.swift
//  RandomUsername
//

import Foundation

final class MockUsersStorage: UsersStorageProtocol {
    private(set) var storedUsers: [RandomUser] = []
    private(set) var storedNextPage: Int = .USERS_STARTING_PAGE

    init(storedUsers: [RandomUser] = [], storedNextPage: Int = .USERS_STARTING_PAGE) {
        self.storedUsers = storedUsers
        self.storedNextPage = storedNextPage
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
}
