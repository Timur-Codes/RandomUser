//
//  Array+UniqueUsersTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

final class ArrayUniqueUsersTests: XCTestCase {
    func testAppendingUniqueUsers_addsNewUsers() {
        let users = [MockRandomUser.sample]
        let updatedUsers = users.appendingUniqueUsers([MockRandomUser.other])

        XCTAssertEqual(updatedUsers.map(\.uuid), [
            MockRandomUser.sample.uuid,
            MockRandomUser.other.uuid
        ])
    }

    func testAppendingUniqueUsers_skipsDuplicates() {
        let users = [MockRandomUser.sample]
        let updatedUsers = users.appendingUniqueUsers([MockRandomUser.sample, MockRandomUser.other])

        XCTAssertEqual(updatedUsers.map(\.uuid), [
            MockRandomUser.sample.uuid,
            MockRandomUser.other.uuid
        ])
    }
}
