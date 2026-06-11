//
//  RandomUser+ListDisplay.swift
//  RandomUsername
//

import Foundation

extension RandomUser {
    var uuid: String {
        login.uuid
    }

    var fullName: String {
        "\(name.first) \(name.last)"
    }

    var thumbnailURL: URL? {
        URL(string: picture.thumbnail)
    }
}
