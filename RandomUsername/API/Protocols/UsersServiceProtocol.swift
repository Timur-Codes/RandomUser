//
//  UsersServiceProtocol.swift
//  RandomUsername
//

import Foundation

protocol UsersServiceProtocol {
    func fetchUsers(results: Int, page: Int) async throws -> [RandomUser]
}
