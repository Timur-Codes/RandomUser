//
//  APIRouting.swift
//  RandomUsername
//

import Foundation

protocol APIRouting {
    var host: String { get }
    var scheme: String { get }
    var path: String { get }
    var method: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String]? { get }
}
