//
//  UsersAPIRouter.swift
//  RandomUsername
//

import Foundation

enum UsersAPIRouter: APIRouting {
    typealias ResultsCount = Int

    case fetchUsers(ResultsCount)

    var host: String {
        switch self {
        case .fetchUsers:
            return "api.randomuser.me"
        }
    }

    var scheme: String {
        switch self {
        case .fetchUsers:
            return "https"
        }
    }

    var path: String {
        switch self {
        case .fetchUsers:
            return "/"
        }
    }

    var method: String {
        switch self {
        case .fetchUsers:
            HTTPMethod.GET.rawValue
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case let .fetchUsers(results):
            return [
                URLQueryItem(name: "results", value: "\(results)")
            ]
        }
    }

    var headers: [String: String]? {
        switch self {
        case .fetchUsers:
            nil
        }
    }
}
