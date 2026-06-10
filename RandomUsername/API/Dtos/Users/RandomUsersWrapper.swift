//
//  RandomUsersWrapper.swift
//  RandomUsername
//

import Foundation

struct RandomUsersInfo: Codable, Sendable {
    let seed: String
    let results: Int
    let page: Int
    let version: String
}

struct RandomUsersWrapper: Codable, Sendable {
    let results: [RandomUser]
    let info: RandomUsersInfo
}
