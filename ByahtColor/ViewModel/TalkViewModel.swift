//
//  TalkViewModel.swift
//  ByahtColor
//
//  Created by jaem on 6/11/24.
//

import Alamofire
import Combine

class TalkViewModel: ObservableObject {
    @Published var results: [Talk] = []
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()

    func fetchTalk(nation: String) {
        isLoading = true
        let url = "\(Bundle.main.TEST_URL)/board/sel"
        let parameters: [String: Any] = [ "user_id": User.shared.id ?? "",
                                          "nation": nation]

        AF.request(url, method: .get, parameters: parameters)
            .responseDecodable(of: [Talk].self) { response in
                switch response.result {
                case .success(let data):
                    do {
                        DispatchQueue.main.async {
                            self.results = data
                            self.isLoading = false
                        }
                    }

                case .failure(let error):
                    print("Error fetching boards: \(error.localizedDescription)")
                    self.isLoading = false
                }

            }
    }
}
