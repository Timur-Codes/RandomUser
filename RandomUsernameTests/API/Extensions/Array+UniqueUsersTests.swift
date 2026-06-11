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

    func testAppendingUniqueUsers_skipsExcludedUsers() {
        let users = [MockRandomUser.sample]
        let updatedUsers = users.appendingUniqueUsers(
            [MockRandomUser.other],
            excluding: [MockRandomUser.other.uuid]
        )

        XCTAssertEqual(updatedUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testExcludingUsers_removesMatchingIDs() {
        let users = [MockRandomUser.sample, MockRandomUser.other]
        let filteredUsers = users.excludingUsers(withIDs: [MockRandomUser.sample.uuid])

        XCTAssertEqual(filteredUsers.map(\.uuid), [MockRandomUser.other.uuid])
    }
}
