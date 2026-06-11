//
//  UserDetailScreen.swift
//  RandomUsername
//

import SwiftUI

struct UserDetailScreen: View {
    let user: RandomUser

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                userImage

                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(label: "Gender", value: user.displayGender)
                    DetailRow(label: "Name", value: user.fullName)
                    DetailRow(label: "Street", value: user.streetAddress)
                    DetailRow(label: "City", value: user.location.city)
                    DetailRow(label: "State", value: user.location.state)
                    DetailRow(label: "Registered", value: user.formattedRegisteredDate)
                    DetailRow(label: "Email", value: user.email)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle(user.fullName)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var userImage: some View {
        if let imageURL = user.largePictureURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 160, height: 160)
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(.secondary)
                @unknown default:
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 160, height: 160)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundStyle(.secondary)
                .frame(width: 160, height: 160)
        }
    }
}

#Preview {
    NavigationStack {
        UserDetailScreen(user: MockRandomUser.sample)
    }
}
