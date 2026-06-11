//
//  MockUsersClient.swift
//  RandomUsername
//

import Foundation

final class MockUsersClient: UsersServiceProtocol {
    let usersByPage: [Int: [RandomUser]]
    let shouldThrowError: Bool

    init(users: [RandomUser] = [], shouldThrowError: Bool = false) {
        self.usersByPage = [.USERS_STARTING_PAGE: users]
        self.shouldThrowError = shouldThrowError
    }

    init(usersByPage: [Int: [RandomUser]], shouldThrowError: Bool = false) {
        self.usersByPage = usersByPage
        self.shouldThrowError = shouldThrowError
    }

    func fetchUsers(results: Int, page: Int) async throws -> [RandomUser] {
        if shouldThrowError {
            throw APIRequestError.noData
        }

        let users = usersByPage[page] ?? []
        return Array(users.prefix(results))
    }
}
