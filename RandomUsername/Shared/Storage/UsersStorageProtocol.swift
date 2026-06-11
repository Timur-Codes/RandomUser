//
//  UsersStorageProtocol.swift
//  RandomUsername
//

import Foundation

protocol UsersStorageProtocol {
    func getUsers() -> [RandomUser]
    func saveUsers(_ users: [RandomUser])
    func getNextPage() -> Int
    func saveNextPage(_ page: Int)
}
