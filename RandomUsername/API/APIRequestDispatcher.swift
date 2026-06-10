//
//  APIRequestDispatcher.swift
//  RandomUsername
//

import Foundation

class APIRequestDispatcher {
    class func request<T: Codable>(apiRouter: APIRouting) async throws -> T {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        components.queryItems = apiRouter.parameters

        guard let url = components.url else { throw APIRequestError.badURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.method

        apiRouter.headers?.forEach { headerField, value in
            urlRequest.setValue(value, forHTTPHeaderField: headerField)
        }

        let session = URLSession(configuration: .default)
        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = session.dataTask(with: urlRequest) { data, _, error in
                if let error {
                    return continuation.resume(with: .failure(error))
                }

                guard let data else {
                    return continuation.resume(with: .failure(APIRequestError.noData))
                }

                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        return continuation.resume(with: .success(responseObject))
                    }
                } catch {
                    return continuation.resume(with: .failure(error))
                }
            }
            dataTask.resume()
        }
    }

    class func request(apiRouter: APIRouting) async throws {
        var components = URLComponents()
        components.host = apiRouter.host
        components.scheme = apiRouter.scheme
        components.path = apiRouter.path
        components.queryItems = apiRouter.parameters

        guard let url = components.url else { throw APIRequestError.badURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.method

        apiRouter.headers?.forEach { headerField, value in
            urlRequest.setValue(value, forHTTPHeaderField: headerField)
        }

        let session = URLSession(configuration: .default)
        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = session.dataTask(with: urlRequest) { _, _, error in
                if let error {
                    return continuation.resume(with: .failure(error))
                }

                continuation.resume(returning: ())
            }
            dataTask.resume()
        }
    }
}
