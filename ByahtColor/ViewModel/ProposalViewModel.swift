//
//  ProposalViewModel.swift
//  ByahtColor
//
//  Created by jaem on 8/20/24.
//

import Foundation
import Alamofire
import Combine

class ProposalViewModel: ObservableObject {

    func updateProposal(business_id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let url = "\(Bundle.main.TEST_URL)/proposal"
        let parameters: [String: Any] = [
            "influence_id": User.shared.id ?? "",
            "business_id": business_id
        ]
        
        AF.request(url, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func deleteProposal(member_id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let url = "\(Bundle.main.TEST_URL)/proposal"
        let parameters: [String: Any] = [
            "influence_id": member_id ,
            "business_id": User.shared.id ?? ""
        ]
        
        AF.request(url, method: .patch, parameters: parameters)
            .validate()
            .responseDecodable(of: Bool.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

}
