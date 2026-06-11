//
//  MockRandomUser.swift
//  RandomUsername
//

import Foundation

enum MockRandomUser {
    static let sample = RandomUser(
        gender: "female",
        name: RandomUserName(title: "Ms", first: "Rigtje", last: "Derikx"),
        location: RandomUserLocation(
            street: RandomUserStreet(number: 7929, name: "Bentveldsduin"),
            city: "Tersoal",
            state: "Drenthe",
            country: "Netherlands",
            postcode: "9489 SU"
        ),
        email: "rigtje.derikx@example.com",
        login: RandomUserLogin(
            uuid: "c2c9c2d0-0687-436a-9058-ccf318cdfedf",
            username: "lazyrabbit805",
            password: "frosty",
            salt: "zGBoAPuc",
            md5: "b500986a25416570b959926fcd3716df",
            sha1: "4421dd69f0dd82fc7369f4e5ef7943d1e6100ee9",
            sha256: "4849bbfe2474843f3c7438f090c06ebbfe1fcbd90ef5e72c21a3598c5a65624f"
        ),
        dob: RandomUserDateInfo(date: "2001-03-31T15:12:51.045Z", age: 25),
        registered: RandomUserDateInfo(date: "2007-01-21T19:02:59.322Z", age: 19),
        phone: "(057) 8988935",
        cell: "(06) 64124167",
        id: RandomUserID(name: "BSN", value: "58826736"),
        picture: RandomUserPicture(
            large: "https://randomuser.me/api/portraits/women/8.jpg",
            medium: "https://randomuser.me/api/portraits/med/women/8.jpg",
            thumbnail: "https://randomuser.me/api/portraits/thumb/women/8.jpg"
        ),
        nat: "NL"
    )

    static let other = RandomUser(
        gender: "male",
        name: RandomUserName(title: "Mr", first: "John", last: "Smith"),
        location: RandomUserLocation(
            street: RandomUserStreet(number: 1, name: "Main St"),
            city: "London",
            state: "England",
            country: "United Kingdom",
            postcode: "SW1A 1AA"
        ),
        email: "john.smith@example.com",
        login: RandomUserLogin(
            uuid: "00000000-0000-0000-0000-000000000001",
            username: "johnsmith",
            password: "secret",
            salt: "salt",
            md5: "md5",
            sha1: "sha1",
            sha256: "sha256"
        ),
        dob: RandomUserDateInfo(date: "1990-01-01T00:00:00.000Z", age: 36),
        registered: RandomUserDateInfo(date: "2010-01-01T00:00:00.000Z", age: 16),
        phone: "123",
        cell: "456",
        id: RandomUserID(name: nil, value: nil),
        picture: RandomUserPicture(
            large: "https://example.com/large.jpg",
            medium: "https://example.com/medium.jpg",
            thumbnail: "https://example.com/thumb.jpg"
        ),
        nat: "GB"
    )
}
