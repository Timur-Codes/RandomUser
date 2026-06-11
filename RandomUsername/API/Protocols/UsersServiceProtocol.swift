//
//  UsersServiceProtocol.swift
//  RandomUsername
//

import Foundation

protocol UsersServiceProtocol {
    func fetchUsers(results: Int) async throws -> [RandomUser]
}
