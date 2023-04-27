//
//  NetworkManager.swift
//  Quote-Combine
//
//  Created by ShafiulAlam-00058 on 4/13/23.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private var cancellable: Set<AnyCancellable> = []
    
    func getData() -> Future<QuoteModel, URLError> {
        return Future { [weak self] promise in
            guard let self = self, let url = URL(string: "https://api.quotable.io/random") else {
                return promise(.failure(URLError.init(.badURL)))
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap({ (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                    return data
                })
                .decode(type: QuoteModel.self, decoder: JSONDecoder())
                .sink { completion in
                    print("completion: \(completion)")
                } receiveValue: { data in
                    promise(.success(data))
                }
                .store(in: &self.cancellable)
        }
    }
    
}
