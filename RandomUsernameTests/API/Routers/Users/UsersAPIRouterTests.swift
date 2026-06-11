//
//  UsersAPIRouterTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

final class UsersAPIRouterTests: XCTestCase {
    var usersAPIRouter: UsersAPIRouter!

    override func setUp() async throws {
        usersAPIRouter = .fetchUsers(40, 1)
    }

    func testUsersHost() {
        XCTAssertEqual(usersAPIRouter.host, "api.randomuser.me")
    }

    func testUsersScheme() {
        XCTAssertEqual(usersAPIRouter.scheme, "https")
    }

    func testUsersPath() {
        XCTAssertEqual(usersAPIRouter.path, "/")
    }

    func testUsersMethod() {
        XCTAssertEqual(usersAPIRouter.method, "GET")
    }

    func testFetchUsersParameters() {
        let expectedParameters = [
            URLQueryItem(name: "results", value: "40"),
            URLQueryItem(name: "page", value: "1")
        ]

        XCTAssertEqual(usersAPIRouter.parameters, expectedParameters)
    }

    func testFetchUsersHeaders() {
        XCTAssertNil(usersAPIRouter.headers)
    }

    func testFetchUsersRequestURL() {
        var components = URLComponents()
        components.host = usersAPIRouter.host
        components.scheme = usersAPIRouter.scheme
        components.path = usersAPIRouter.path
        components.queryItems = usersAPIRouter.parameters

        XCTAssertNotNil(components.url)
        XCTAssertEqual(
            components.url?.absoluteString,
            "https://api.randomuser.me/?results=40&page=1"
        )
    }
}
