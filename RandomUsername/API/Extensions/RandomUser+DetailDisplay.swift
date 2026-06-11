//
//  RandomUser+DetailDisplay.swift
//  RandomUsername
//

import Foundation

extension RandomUser {
    var displayGender: String {
        gender.capitalized
    }

    var streetAddress: String {
        "\(location.street.number) \(location.street.name)"
    }

    var largePictureURL: URL? {
        URL(string: picture.large)
    }

    var formattedRegisteredDate: String {
        guard let date = Self.parseRegisteredDate(registered.date) else {
            return registered.date
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }

    private static func parseRegisteredDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return date
    }
}
