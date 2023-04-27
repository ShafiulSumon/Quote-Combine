//
//  QuoteViewModel.swift
//  Quote-Combine
//
//  Created by ShafiulAlam-00058 on 4/13/23.
//

import Foundation
import Combine

class QuoteViewModel: ObservableObject {
    
    @Published var quote: QuoteModel = QuoteModel()
    @Published var spinner: Bool = false
    
    private var cancellable: Set<AnyCancellable> = []
    
    func fetchQuote() {
        self.spinner = true
        
        NetworkManager.shared.getData().sink { completion in
            switch completion {
            case .finished:
                print("success")
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { value in
            self.quote = value
            self.spinner = false
        }
        .store(in: &cancellable)
    }
}
