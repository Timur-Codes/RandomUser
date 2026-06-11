//
//  UsersListScreen.swift
//  RandomUsername
//

import SwiftUI

struct UsersListScreen: View {
    @State private var viewModel: UsersListViewModel

    init() {
        _viewModel = State(wrappedValue: UsersListViewModel(usersClient: UsersClient()))
    }

    init(viewModel: UsersListViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Random Users")
        }
        .task {
            await viewModel.loadUsersIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .loading:
            ProgressView("Loading users…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded:
            List(viewModel.users, id: \.uuid) { user in
                NavigationLink(value: user) {
                    UserRowView(user: user)
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: RandomUser.self) { user in
                UserDetailScreen(user: user)
            }

        case let .error(message):
            ContentUnavailableView {
                Label("Could Not Load Users", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") {
                    Task {
                        await viewModel.loadUsers()
                    }
                }
            }
        }
    }
}

#Preview("Loaded") {
    UsersListScreen(
        viewModel: UsersListViewModel(
            usersClient: MockUsersClient(),
            initialUsers: [MockRandomUser.sample]
        )
    )
}

#Preview("Loading") {
    UsersListScreen()
}
