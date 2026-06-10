//
//  UsersProtocol.swift
//  RandomUsername
//

import Foundation

protocol UsersProtocol {
    func fetchUsers(results: Int) async throws -> [RandomUser]
}
