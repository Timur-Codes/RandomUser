//
//  RandomUserLocation.swift
//  RandomUsername
//

import Foundation

struct RandomUserLocation: Codable, Sendable {
    let street: RandomUserStreet
    let city: String
    let state: String
    let country: String
    let postcode: String

    init(street: RandomUserStreet, city: String, state: String, country: String, postcode: String) {
        self.street = street
        self.city = city
        self.state = state
        self.country = country
        self.postcode = postcode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        street = try container.decode(RandomUserStreet.self, forKey: .street)
        city = try container.decode(String.self, forKey: .city)
        state = try container.decode(String.self, forKey: .state)
        country = try container.decode(String.self, forKey: .country)
        postcode = try container.decodePostcode(forKey: .postcode)
    }
}

private extension KeyedDecodingContainer {
    func decodePostcode(forKey key: Key) throws -> String {
        if let stringValue = try? decode(String.self, forKey: key) {
            return stringValue
        }

        if let intValue = try? decode(Int.self, forKey: key) {
            return String(intValue)
        }

        throw DecodingError.typeMismatch(
            String.self,
            DecodingError.Context(
                codingPath: codingPath + [key],
                debugDescription: "Expected postcode to be a String or Int"
            )
        )
    }
}
