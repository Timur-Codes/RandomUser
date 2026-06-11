//
//  Array+UniqueUsers.swift
//  RandomUsername
//

import Foundation

extension Array where Element == RandomUser {
    func appendingUniqueUsers(_ newUsers: [RandomUser]) -> [RandomUser] {
        let existingUUIDs = Set(map(\.uuid))
        let uniqueNewUsers = newUsers.filter { !existingUUIDs.contains($0.uuid) }

        return self + uniqueNewUsers
    }
}
