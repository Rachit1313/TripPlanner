//
//  Service.swift
//  TripPlanner
//
//  Created by Rachit Chawla on 08/04/24.
//

import Foundation

class Service {
    static var shared = Service()
    private init() { }

    enum error: Error {
        case badURL
    }

    func getData(url: String, query: [String: String]?, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlComponent = URLComponents(string: url)!
        if let query = query {
            urlComponent.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponent.url else {
            print("Bad URL")
            completion(.failure(error.badURL))
            return
        }
        print("Making request to URL: \(url)")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Network request error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                print("Network request succeeded, data received")
                completion(.success(data))
            } else {
                print("Network request succeeded, no data received")
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
}
