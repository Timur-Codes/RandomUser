//
//  UsersStorage.swift
//  RandomUsername
//

import Foundation

final class UsersStorage: UsersStorageProtocol {
    private let userDefaults: UserDefaults
    private let usersKey = "savedUsers"
    private let nextPageKey = "nextPage"
    private let deletedUserIDsKey = "deletedUserIDs"

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

    func getNextPage() -> Int {
        guard userDefaults.object(forKey: nextPageKey) != nil else {
            return getUsers().isEmpty ? .USERS_STARTING_PAGE : .USERS_STARTING_PAGE + 1
        }

        return userDefaults.integer(forKey: nextPageKey)
    }

    func saveNextPage(_ page: Int) {
        userDefaults.set(page, forKey: nextPageKey)
    }

    func getDeletedUserIDs() -> Set<String> {
        guard let data = userDefaults.data(forKey: deletedUserIDsKey),
              let ids = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }

        return Set(ids)
    }

    func addDeletedUserID(_ id: String) {
        var deletedUserIDs = getDeletedUserIDs()
        deletedUserIDs.insert(id)

        guard let data = try? JSONEncoder().encode(Array(deletedUserIDs)) else { return }

        userDefaults.set(data, forKey: deletedUserIDsKey)
    }
}
