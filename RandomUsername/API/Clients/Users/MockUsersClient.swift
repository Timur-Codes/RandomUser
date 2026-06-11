//
//  MockUsersClient.swift
//  RandomUsername
//

import Foundation

final class MockUsersClient: UsersServiceProtocol {
    let users: [RandomUser]
    let shouldThrowError: Bool

    init(users: [RandomUser] = [], shouldThrowError: Bool = false) {
        self.users = users
        self.shouldThrowError = shouldThrowError
    }

    func fetchUsers(results: Int) async throws -> [RandomUser] {
        if shouldThrowError {
            throw APIRequestError.noData
        }

        if users.isEmpty {
            return []
        }

        return Array(users.prefix(results))
    }
}
