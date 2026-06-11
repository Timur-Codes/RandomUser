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

        guard let url = components.url else {
            print("[APIRequestDispatcher] Failed to build URL for host: \(apiRouter.host), path: \(apiRouter.path)")
            throw APIRequestError.badURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = apiRouter.method

        apiRouter.headers?.forEach { headerField, value in
            urlRequest.setValue(value, forHTTPHeaderField: headerField)
        }

        let session = URLSession(configuration: .default)
        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = session.dataTask(with: urlRequest) { data, _, error in
                if let error {
                    print("[APIRequestDispatcher] Request failed: \(error.localizedDescription)")
                    return continuation.resume(with: .failure(error))
                }

                guard let data else {
                    print("[APIRequestDispatcher] No data received for \(url.absoluteString)")
                    return continuation.resume(with: .failure(APIRequestError.noData))
                }

                do {
                    let responseObject = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        continuation.resume(with: .success(responseObject))
                    }
                } catch {
                    print("[APIRequestDispatcher] Decoding failed: \(error)")
                    return continuation.resume(with: .failure(error))
                }
            }
            dataTask.resume()
        }
    }
}
