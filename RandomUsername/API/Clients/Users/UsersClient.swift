//
//  UsersClient.swift
//  RandomUsername
//

import Foundation

final class UsersClient: UsersProtocol {
    func fetchUsers(results: Int = .USERS_FETCHING_LIMIT) async throws -> [RandomUser] {
        let usersAPIRouter: UsersAPIRouter = .fetchUsers(results)
        let usersWrapper: RandomUsersWrapper = try await APIRequestDispatcher.request(apiRouter: usersAPIRouter)

        return usersWrapper.results
    }
}
