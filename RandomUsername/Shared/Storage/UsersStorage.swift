//
//  UsersStorage.swift
//  RandomUsername
//

import Foundation

final class UsersStorage: UsersStorageProtocol {
    private let userDefaults: UserDefaults
    private let usersKey = "savedUsers"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func getUsers() -> [RandomUser] {
        guard let data = userDefaults.data(forKey: usersKey),
              let users = try? JSONDecoder().decode([RandomUser].self, from: data) else {
            return []
        }

        return users
    }

    func saveUsers(_ users: [RandomUser]) {
        guard let data = try? JSONEncoder().encode(users) else { return }

        userDefaults.set(data, forKey: usersKey)
    }
}
