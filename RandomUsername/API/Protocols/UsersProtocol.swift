//
//  UsersProtocol.swift
//  RandomUsername
//

import Foundation

protocol UsersProtocol: Sendable {
    func fetchUsers(results: Int) async throws -> [RandomUser]
}
