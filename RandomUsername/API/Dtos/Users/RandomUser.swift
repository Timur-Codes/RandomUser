//
//  RandomUser.swift
//  RandomUsername
//

import Foundation

struct RandomUser: Codable, Sendable {
    let gender: String
    let name: RandomUserName
    let location: RandomUserLocation
    let email: String
    let login: RandomUserLogin
    let dob: RandomUserDateInfo
    let registered: RandomUserDateInfo
    let phone: String
    let cell: String
    let id: RandomUserID?
    let picture: RandomUserPicture
    let nat: String
}
