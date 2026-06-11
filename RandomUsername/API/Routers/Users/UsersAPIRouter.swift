//
//  UsersAPIRouter.swift
//  RandomUsername
//

import Foundation

enum UsersAPIRouter: APIRouting {
    typealias ResultsCount = Int
    typealias Page = Int

    case fetchUsers(ResultsCount, Page)

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
        case let .fetchUsers(results, page):
            return [
                URLQueryItem(name: "results", value: "\(results)"),
                URLQueryItem(name: "page", value: "\(page)")
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
