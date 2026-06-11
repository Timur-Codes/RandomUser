//
//  UsersListViewModelTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

@MainActor
final class UsersListViewModelTests: XCTestCase {
    func testInitialState_isLoadingWithNoUsers() {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(),
            usersStorage: MockUsersStorage()
        )

        XCTAssertEqual(viewModel.viewState, .loading)
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testLoadUsers_success_setsUsersAndLoadedState() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsers_success_savesUsersToStorage() async {
        let storage = MockUsersStorage()
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: storage
        )

        await viewModel.loadUsers()

        XCTAssertEqual(storage.storedUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsers_success_savesNextPage() async {
        let storage = MockUsersStorage()
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: storage
        )

        await viewModel.loadUsers()

        XCTAssertEqual(storage.storedNextPage, .USERS_STARTING_PAGE + 1)
    }

    func testLoadUsers_failure_setsErrorState() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(shouldThrowError: true),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.viewState, .error(APIRequestError.noData.localizedDescription))
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testLoadUsersIfNeeded_whenStorageHasUsers_loadsWithoutFetching() async {
        let storage = MockUsersStorage(
            storedUsers: [MockRandomUser.sample],
            storedNextPage: 2
        )
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: []),
            usersStorage: storage
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadMoreUsersIfNeeded_appendsNextPageUsers() async {
        let storage = MockUsersStorage()
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(usersByPage: [
                1: [MockRandomUser.sample],
                2: [MockRandomUser.other]
            ]),
            usersStorage: storage
        )

        await viewModel.loadUsers()
        await viewModel.loadMoreUsersIfNeeded(currentUser: MockRandomUser.sample)

        XCTAssertEqual(viewModel.users.map(\.uuid), [
            MockRandomUser.sample.uuid,
            MockRandomUser.other.uuid
        ])
        XCTAssertEqual(storage.storedNextPage, 3)
    }

    func testLoadMoreUsersIfNeeded_skipsDuplicateUsers() async {
        let storage = MockUsersStorage()
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(usersByPage: [
                1: [MockRandomUser.sample],
                2: [MockRandomUser.sample, MockRandomUser.other]
            ]),
            usersStorage: storage
        )

        await viewModel.loadUsers()
        await viewModel.loadMoreUsersIfNeeded(currentUser: MockRandomUser.sample)

        XCTAssertEqual(viewModel.users.map(\.uuid), [
            MockRandomUser.sample.uuid,
            MockRandomUser.other.uuid
        ])
    }

    func testDeleteUser_removesUserAndPersistsDeletedID() async {
        let storage = MockUsersStorage()
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample, MockRandomUser.other]),
            usersStorage: storage
        )

        await viewModel.loadUsers()
        viewModel.deleteUser(MockRandomUser.sample)

        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.other.uuid])
        XCTAssertEqual(storage.storedUsers.map(\.uuid), [MockRandomUser.other.uuid])
        XCTAssertEqual(storage.deletedUserIDs, [MockRandomUser.sample.uuid])
    }

    func testLoadMoreUsersIfNeeded_excludesPreviouslyDeletedUsers() async {
        let storage = MockUsersStorage(deletedUserIDs: [MockRandomUser.other.uuid])
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(usersByPage: [
                1: [MockRandomUser.sample],
                2: [MockRandomUser.other, MockRandomUser.sample]
            ]),
            usersStorage: storage
        )

        await viewModel.loadUsers()
        await viewModel.loadMoreUsersIfNeeded(currentUser: MockRandomUser.sample)

        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsersIfNeeded_excludesDeletedUsersFromStorage() async {
        let storage = MockUsersStorage(
            storedUsers: [MockRandomUser.sample, MockRandomUser.other],
            storedNextPage: 2,
            deletedUserIDs: [MockRandomUser.sample.uuid]
        )
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: []),
            usersStorage: storage
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.other.uuid])
    }

    func testLoadMoreUsersIfNeeded_doesNotFetchForNonLastUser() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(usersByPage: [
                1: [MockRandomUser.sample, MockRandomUser.other],
                2: [MockRandomUser.sample]
            ]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        await viewModel.loadMoreUsersIfNeeded(currentUser: MockRandomUser.sample)

        XCTAssertEqual(viewModel.users.count, 2)
    }

    func testLoadUsersIfNeeded_whenAlreadyLoaded_keepsExistingUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsersIfNeeded_whenStorageIsEmpty_fetchesUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsersIfNeeded_whenInErrorState_retriesFetch() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(shouldThrowError: true),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .error(APIRequestError.noData.localizedDescription))
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testFilteredUsers_withEmptySearchText_returnsAllUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = ""

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), viewModel.users.map(\.uuid))
    }

    func testFilteredUsers_matchesFirstName() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Rigtje"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_matchesLastName() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Derikx"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_matchesEmail() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "rigtje.derikx"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_withNoMatches_returnsEmptyList() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "not-a-match"

        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
    }

    func testShowsEmptySearchResults_isFalseWithEmptySearchText() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = ""

        XCTAssertFalse(viewModel.showsEmptySearchResults)
    }

    func testShowsEmptySearchResults_isTrueWithNoMatches() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "not-a-match"

        XCTAssertTrue(viewModel.showsEmptySearchResults)
    }

    func testShowsEmptySearchResults_isFalseWithMatches() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample]),
            usersStorage: MockUsersStorage()
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Rigtje"

        XCTAssertFalse(viewModel.showsEmptySearchResults)
    }
}
