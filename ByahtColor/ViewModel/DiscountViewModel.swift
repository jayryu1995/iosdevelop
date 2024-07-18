//
//  DiscountViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/11/24.
//

import Foundation
import Combine
import Alamofire

class DiscountViewModel: ObservableObject {
    @Published var result: [DiscountDto] = []
    @Published var isLoading: Bool = false
    var cancellables = Set<AnyCancellable>()

    func loadData(url: String) {
        isLoading = true

        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [DiscountDto].self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error loading data: \(error.localizedDescription)")
                    log(vc: "DiscountViewModel", message: "Select Discount Error : \(error)")
                }
            }, receiveValue: { [weak self] value in
                self?.result = value
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
}
