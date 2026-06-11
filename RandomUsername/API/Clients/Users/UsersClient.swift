//
//  UsersClient.swift
//  RandomUsername
//

import Foundation

final class UsersClient: UsersServiceProtocol {
    func fetchUsers(results: Int, page: Int) async throws -> [RandomUser] {
        let usersAPIRouter: UsersAPIRouter = .fetchUsers(results, page)
        let usersWrapper: RandomUsersWrapper = try await APIRequestDispatcher.request(apiRouter: usersAPIRouter)

        return usersWrapper.results
    }
}
