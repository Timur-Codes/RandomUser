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
}
