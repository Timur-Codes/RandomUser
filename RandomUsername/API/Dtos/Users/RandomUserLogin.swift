//
//  RandomUserLogin.swift
//  RandomUsername
//

import Foundation

struct RandomUserLogin: Codable, Sendable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}
