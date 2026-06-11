//
//  Array+UniqueUsers.swift
//  RandomUsername
//

import Foundation

extension Array where Element == RandomUser {
    func appendingUniqueUsers(_ newUsers: [RandomUser], excluding excludedUUIDs: Set<String> = []) -> [RandomUser] {
        let existingUUIDs = Set(map(\.uuid))
        let uniqueNewUsers = newUsers.filter {
            !existingUUIDs.contains($0.uuid) && !excludedUUIDs.contains($0.uuid)
        }

        return self + uniqueNewUsers
    }

    func excludingUsers(withIDs excludedUUIDs: Set<String>) -> [RandomUser] {
        filter { !excludedUUIDs.contains($0.uuid) }
    }
}
