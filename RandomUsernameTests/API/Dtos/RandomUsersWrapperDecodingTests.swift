//
//  RandomUsersWrapperDecodingTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

final class RandomUsersWrapperDecodingTests: XCTestCase {
    private var wrapper: RandomUsersWrapper!
    private var user: RandomUser!

    override func setUpWithError() throws {
        try super.setUpWithError()

        let data = try XCTUnwrap(Self.json.data(using: .utf8))
        wrapper = try JSONDecoder().decode(RandomUsersWrapper.self, from: data)
        user = try XCTUnwrap(wrapper.results.first)
    }

    func testDecodesResultsCount() {
        XCTAssertEqual(wrapper.results.count, 1)
    }

    func testDecodesGender() {
        XCTAssertEqual(user.gender, "female")
    }

    func testDecodesNameTitle() {
        XCTAssertEqual(user.name.title, "Ms")
    }

    func testDecodesNameFirst() {
        XCTAssertEqual(user.name.first, "Rigtje")
    }

    func testDecodesNameLast() {
        XCTAssertEqual(user.name.last, "Derikx")
    }

    func testDecodesStreetNumber() {
        XCTAssertEqual(user.location.street.number, 7929)
    }

    func testDecodesStreetName() {
        XCTAssertEqual(user.location.street.name, "Bentveldsduin")
    }

    func testDecodesCity() {
        XCTAssertEqual(user.location.city, "Tersoal")
    }

    func testDecodesState() {
        XCTAssertEqual(user.location.state, "Drenthe")
    }

    func testDecodesCountry() {
        XCTAssertEqual(user.location.country, "Netherlands")
    }

    func testDecodesPostcode() {
        XCTAssertEqual(user.location.postcode, "9489 SU")
    }

    func testDecodesEmail() {
        XCTAssertEqual(user.email, "rigtje.derikx@example.com")
    }

    func testDecodesLoginUUID() {
        XCTAssertEqual(user.login.uuid, "c2c9c2d0-0687-436a-9058-ccf318cdfedf")
    }

    func testDecodesLoginUsername() {
        XCTAssertEqual(user.login.username, "lazyrabbit805")
    }

    func testDecodesLoginPassword() {
        XCTAssertEqual(user.login.password, "frosty")
    }

    func testDecodesLoginSalt() {
        XCTAssertEqual(user.login.salt, "zGBoAPuc")
    }

    func testDecodesLoginMD5() {
        XCTAssertEqual(user.login.md5, "b500986a25416570b959926fcd3716df")
    }

    func testDecodesLoginSHA1() {
        XCTAssertEqual(user.login.sha1, "4421dd69f0dd82fc7369f4e5ef7943d1e6100ee9")
    }

    func testDecodesLoginSHA256() {
        XCTAssertEqual(user.login.sha256, "4849bbfe2474843f3c7438f090c06ebbfe1fcbd90ef5e72c21a3598c5a65624f")
    }

    func testDecodesDobDate() {
        XCTAssertEqual(user.dob.date, "2001-03-31T15:12:51.045Z")
    }

    func testDecodesDobAge() {
        XCTAssertEqual(user.dob.age, 25)
    }

    func testDecodesRegisteredDate() {
        XCTAssertEqual(user.registered.date, "2007-01-21T19:02:59.322Z")
    }

    func testDecodesRegisteredAge() {
        XCTAssertEqual(user.registered.age, 19)
    }

    func testDecodesPhone() {
        XCTAssertEqual(user.phone, "(057) 8988935")
    }

    func testDecodesCell() {
        XCTAssertEqual(user.cell, "(06) 64124167")
    }

    func testDecodesIDName() {
        XCTAssertEqual(user.id?.name, "BSN")
    }

    func testDecodesIDValue() {
        XCTAssertEqual(user.id?.value, "58826736")
    }

    func testDecodesPictureLarge() {
        XCTAssertEqual(user.picture.large, "https://randomuser.me/api/portraits/women/8.jpg")
    }

    func testDecodesPictureMedium() {
        XCTAssertEqual(user.picture.medium, "https://randomuser.me/api/portraits/med/women/8.jpg")
    }

    func testDecodesPictureThumbnail() {
        XCTAssertEqual(user.picture.thumbnail, "https://randomuser.me/api/portraits/thumb/women/8.jpg")
    }

    func testDecodesNat() {
        XCTAssertEqual(user.nat, "NL")
    }

    func testDecodesInfoSeed() {
        XCTAssertEqual(wrapper.info.seed, "3ffd5aa50ae35062")
    }

    func testDecodesInfoResults() {
        XCTAssertEqual(wrapper.info.results, 1)
    }

    func testDecodesInfoPage() {
        XCTAssertEqual(wrapper.info.page, 1)
    }

    func testDecodesInfoVersion() {
        XCTAssertEqual(wrapper.info.version, "1.4")
    }

    func testDecodesNullID() throws {
        let json = """
        {
            "results": [
                {
                    "gender": "male",
                    "name": { "title": "Mr", "first": "John", "last": "Smith" },
                    "location": {
                        "street": { "number": 1, "name": "Main St" },
                        "city": "London",
                        "state": "England",
                        "country": "United Kingdom",
                        "postcode": "SW1A 1AA"
                    },
                    "email": "john.smith@example.com",
                    "login": {
                        "uuid": "00000000-0000-0000-0000-000000000001",
                        "username": "john",
                        "password": "secret",
                        "salt": "salt",
                        "md5": "md5",
                        "sha1": "sha1",
                        "sha256": "sha256"
                    },
                    "dob": { "date": "1990-01-01T00:00:00.000Z", "age": 36 },
                    "registered": { "date": "2010-01-01T00:00:00.000Z", "age": 16 },
                    "phone": "123",
                    "cell": "456",
                    "id": { "name": null, "value": null },
                    "picture": {
                        "large": "https://example.com/large.jpg",
                        "medium": "https://example.com/medium.jpg",
                        "thumbnail": "https://example.com/thumb.jpg"
                    },
                    "nat": "GB"
                }
            ],
            "info": { "seed": "abc", "results": 1, "page": 1, "version": "1.4" }
        }
        """

        let data = try XCTUnwrap(json.data(using: .utf8))
        let decodedWrapper = try JSONDecoder().decode(RandomUsersWrapper.self, from: data)

        XCTAssertNil(decodedWrapper.results[0].id?.name)
        XCTAssertNil(decodedWrapper.results[0].id?.value)
    }
}

private extension RandomUsersWrapperDecodingTests {
    static let json = """
    {
        "results": [
            {
                "gender": "female",
                "name": {
                    "title": "Ms",
                    "first": "Rigtje",
                    "last": "Derikx"
                },
                "location": {
                    "street": {
                        "number": 7929,
                        "name": "Bentveldsduin"
                    },
                    "city": "Tersoal",
                    "state": "Drenthe",
                    "country": "Netherlands",
                    "postcode": "9489 SU"
                },
                "email": "rigtje.derikx@example.com",
                "login": {
                    "uuid": "c2c9c2d0-0687-436a-9058-ccf318cdfedf",
                    "username": "lazyrabbit805",
                    "password": "frosty",
                    "salt": "zGBoAPuc",
                    "md5": "b500986a25416570b959926fcd3716df",
                    "sha1": "4421dd69f0dd82fc7369f4e5ef7943d1e6100ee9",
                    "sha256": "4849bbfe2474843f3c7438f090c06ebbfe1fcbd90ef5e72c21a3598c5a65624f"
                },
                "dob": {
                    "date": "2001-03-31T15:12:51.045Z",
                    "age": 25
                },
                "registered": {
                    "date": "2007-01-21T19:02:59.322Z",
                    "age": 19
                },
                "phone": "(057) 8988935",
                "cell": "(06) 64124167",
                "id": {
                    "name": "BSN",
                    "value": "58826736"
                },
                "picture": {
                    "large": "https://randomuser.me/api/portraits/women/8.jpg",
                    "medium": "https://randomuser.me/api/portraits/med/women/8.jpg",
                    "thumbnail": "https://randomuser.me/api/portraits/thumb/women/8.jpg"
                },
                "nat": "NL"
            }
        ],
        "info": {
            "seed": "3ffd5aa50ae35062",
            "results": 1,
            "page": 1,
            "version": "1.4"
        }
    }
    """
}
