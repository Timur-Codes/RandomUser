//
//  UserRowView.swift
//  RandomUsername
//

import SwiftUI

struct UserRowView: View {
    let user: RandomUser

    var body: some View {
        HStack(spacing: 16) {
            userThumbnail

            VStack(alignment: .leading, spacing: 8) {
                Text(user.fullName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Label(locationText, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                VStack(alignment: .leading, spacing: 4) {
                    Label(user.email, systemImage: "envelope")
                    Label(user.phone, systemImage: "phone")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(16)
        .background(cardBackground)
    }

    private var locationText: String {
        "\(user.location.city), \(user.location.country)"
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
            .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }

    @ViewBuilder
    private var userThumbnail: some View {
        if let thumbnailURL = user.thumbnailURL {
            AsyncImage(url: thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 64, height: 64)
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderImage
                @unknown default:
                    placeholderImage
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        } else {
            placeholderImage
                .frame(width: 64, height: 64)
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "person.crop.square.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)
            .padding(12)
            .background(Color(.tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    List {
        UserRowView(user: MockRandomUser.sample)
            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(Color(.systemGroupedBackground))
}
