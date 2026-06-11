//
//  RandomUser+Hashable.swift
//  RandomUsername
//

extension RandomUser: Hashable {
    static func == (lhs: RandomUser, rhs: RandomUser) -> Bool {
        lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
