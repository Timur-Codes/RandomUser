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
}
