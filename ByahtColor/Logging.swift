//
//  Logging.swift
//  ByahtColor
//
//  Created by jaem on 2023/06/20.
//

import Foundation
import UIKit

func log(vc: String, message: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = formatter.string(from: Date())
    let logMessage = "[\(vc)] || \(dateString): \(message)\n"

    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

    let fileURL = documentsDirectory.appendingPathComponent("log.txt")

    if let outputStream = OutputStream(url: fileURL, append: true) {
        outputStream.open()

        let bytesWritten = outputStream.write(logMessage, maxLength: logMessage.lengthOfBytes(using: .utf8))
        if bytesWritten < 0 {
            print("write failure")
        }
        outputStream.close()
        print(logMessage)
    } else {
        print("Unable to open file")
    }
}
