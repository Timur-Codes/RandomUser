//
//  UserRowView.swift
//  RandomUsername
//

import SwiftUI

struct UserRowView: View {
    let user: RandomUser

    var body: some View {
        HStack(spacing: 12) {
            userThumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(user.fullName)
                    .font(.headline)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(user.phone)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var userThumbnail: some View {
        if let thumbnailURL = user.thumbnailURL {
            AsyncImage(url: thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 56, height: 56)
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
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .foregroundStyle(.secondary)
                .frame(width: 56, height: 56)
        }
    }
}

#Preview {
    List {
        UserRowView(user: MockRandomUser.sample)
    }
}
