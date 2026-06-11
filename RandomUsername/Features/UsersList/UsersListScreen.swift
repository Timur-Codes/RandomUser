//
//  UsersListScreen.swift
//  RandomUsername
//

import SwiftUI

struct UsersListScreen: View {
    @State private var viewModel: UsersListViewModel

    init(viewModel: UsersListViewModel) {
        _viewModel = State(wrappedValue: viewModel)
    }

    private var searchTextBinding: Binding<String> {
        Binding(
            get: { viewModel.searchText },
            set: { viewModel.searchText = $0 }
        )
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Random Users")
                .searchable(text: searchTextBinding, prompt: "Search by name or email")
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
            Group {
                if viewModel.showsEmptySearchResults {
                    ContentUnavailableView.search(text: viewModel.searchText)
                } else {
                    List(viewModel.filteredUsers, id: \.uuid) { user in
                        NavigationLink(value: user) {
                            UserRowView(user: user)
                        }
                    }
                    .listStyle(.plain)
                }
            }
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
            usersClient: MockUsersClient(users: [MockRandomUser.sample])
        )
    )
}

#Preview("Loading") {
    UsersListScreen(
        viewModel: UsersListViewModel(usersClient: MockUsersClient())
    )
}
