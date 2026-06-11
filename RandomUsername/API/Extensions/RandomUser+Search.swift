//
//  RandomUser+Search.swift
//  RandomUsername
//

import Foundation

extension RandomUser {
    func matches(searchText: String) -> Bool {
        let lowercasedText = searchText.lowercased()

        return name.first.lowercased().contains(lowercasedText)
            || name.last.lowercased().contains(lowercasedText)
            || email.lowercased().contains(lowercasedText)
    }
}
