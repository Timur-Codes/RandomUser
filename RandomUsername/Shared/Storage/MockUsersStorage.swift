//
//  MockUsersStorage.swift
//  RandomUsername
//

import Foundation

final class MockUsersStorage: UsersStorageProtocol {
    private(set) var storedUsers: [RandomUser] = []

    init(storedUsers: [RandomUser] = []) {
        self.storedUsers = storedUsers
    }

    func getUsers() -> [RandomUser] {
        storedUsers
    }

    func saveUsers(_ users: [RandomUser]) {
        storedUsers = users
    }
}
