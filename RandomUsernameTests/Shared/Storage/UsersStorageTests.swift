//
//  UsersStorageTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

final class UsersStorageTests: XCTestCase {
    private var userDefaults: UserDefaults!
    private var usersStorage: UsersStorage!

    override func setUp() {
        super.setUp()

        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        usersStorage = UsersStorage(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
        userDefaults = nil
        usersStorage = nil

        super.tearDown()
    }

    func testGetUsers_withNoSavedData_returnsEmptyArray() {
        XCTAssertTrue(usersStorage.getUsers().isEmpty)
    }

    func testSaveAndGetUsers_persistsUsers() {
        usersStorage.saveUsers([MockRandomUser.sample])

        XCTAssertEqual(usersStorage.getUsers().map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testGetNextPage_withNoSavedData_returnsStartingPage() {
        XCTAssertEqual(usersStorage.getNextPage(), .USERS_STARTING_PAGE)
    }

    func testGetNextPage_withSavedUsersAndNoStoredPage_returnsNextPage() {
        usersStorage.saveUsers([MockRandomUser.sample])

        XCTAssertEqual(usersStorage.getNextPage(), .USERS_STARTING_PAGE + 1)
    }

    func testSaveAndGetNextPage_persistsPage() {
        usersStorage.saveNextPage(3)

        XCTAssertEqual(usersStorage.getNextPage(), 3)
    }

    func testAddDeletedUserID_persistsDeletedID() {
        usersStorage.addDeletedUserID(MockRandomUser.sample.uuid)

        XCTAssertEqual(usersStorage.getDeletedUserIDs(), [MockRandomUser.sample.uuid])
    }
}
