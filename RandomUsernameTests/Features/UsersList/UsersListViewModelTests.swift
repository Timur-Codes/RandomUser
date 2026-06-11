//
//  UsersListViewModelTests.swift
//  RandomUsernameTests
//

import XCTest
@testable import RandomUsername

@MainActor
final class UsersListViewModelTests: XCTestCase {
    func testInitialState_isLoadingWithNoUsers() {
        let viewModel = UsersListViewModel(usersClient: MockUsersClient())

        XCTAssertEqual(viewModel.viewState, .loading)
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testLoadUsers_success_setsUsersAndLoadedState() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsers_failure_setsErrorState() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(shouldThrowError: true)
        )

        await viewModel.loadUsers()

        XCTAssertEqual(viewModel.viewState, .error(APIRequestError.noData.localizedDescription))
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testLoadUsersIfNeeded_whenAlreadyLoaded_keepsExistingUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsersIfNeeded_whenLoading_fetchesUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .loaded)
        XCTAssertEqual(viewModel.users.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testLoadUsersIfNeeded_whenInErrorState_retriesFetch() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(shouldThrowError: true)
        )

        await viewModel.loadUsersIfNeeded()

        XCTAssertEqual(viewModel.viewState, .error(APIRequestError.noData.localizedDescription))
        XCTAssertTrue(viewModel.users.isEmpty)
    }

    func testFilteredUsers_withEmptySearchText_returnsAllUsers() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = ""

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), viewModel.users.map(\.uuid))
    }

    func testFilteredUsers_matchesFirstName() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Rigtje"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_matchesLastName() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Derikx"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_matchesEmail() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "rigtje.derikx"

        XCTAssertEqual(viewModel.filteredUsers.map(\.uuid), [MockRandomUser.sample.uuid])
    }

    func testFilteredUsers_withNoMatches_returnsEmptyList() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "not-a-match"

        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
    }

    func testShowsEmptySearchResults_isFalseWithEmptySearchText() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = ""

        XCTAssertFalse(viewModel.showsEmptySearchResults)
    }

    func testShowsEmptySearchResults_isTrueWithNoMatches() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "not-a-match"

        XCTAssertTrue(viewModel.showsEmptySearchResults)
    }

    func testShowsEmptySearchResults_isFalseWithMatches() async {
        let viewModel = UsersListViewModel(
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )

        await viewModel.loadUsers()
        viewModel.searchText = "Rigtje"

        XCTAssertFalse(viewModel.showsEmptySearchResults)
    }
}
