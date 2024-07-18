//
//  UploaderClass.swift
//  ByahtColor
//
//  Created by jaem on 2023/06/14.
//

import Alamofire
import UIKit

class UploaderClass {

    func uploadLog(parameters: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentsDirectory.appendingPathComponent("log.txt")
        let url = "\(Bundle.main.TEST_URL)/ios/log"
        let logData = fileURL
        AF.upload(
            multipartFormData: { multipartFormData in
                // add param
                for (key, value) in parameters {
                                multipartFormData.append(value.data(using: .utf8)!, withName: key)
                            }

                // Add log file
                multipartFormData.append(logData, withName: "logFile", fileName: "log.txt", mimeType: "text/plain")
            },
            to: url
        )
        .response { response in
            switch response.result {
            case .success(let data):
                completion(.success(data!))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
