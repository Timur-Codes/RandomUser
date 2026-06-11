//
//  RandomUsernameApp.swift
//  RandomUsername
//
//  Created by Timur Powenda on 10.06.26.
//

import SwiftUI

@main
struct RandomUsernameApp: App {
    var body: some Scene {
        WindowGroup {
            UsersListScreen(
                viewModel: UsersListViewModel(
                    usersClient: UsersClient(),
                    usersStorage: UsersStorage()
                )
            )
        }
    }
}
