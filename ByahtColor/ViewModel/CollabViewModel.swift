//
//  CollabViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/5/24.
//

import Foundation
import Alamofire
import Combine

class CollabViewModel: ObservableObject {
    @Published var collabList: [CollabDto] = []
    @Published var isLoading: Bool = false
    var cancellables = Set<AnyCancellable>()

    func loadData(url: String, userId: String, styles: [String], sns: [String]) {
        isLoading = true

        let parameters = CollabRequestDTO(user_id: userId, styles: styles, sns: sns)
        AF.request(url, method: .post, parameters: parameters, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [CollabDto].self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error loading data: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] collabList in
                self?.collabList = collabList
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
}
