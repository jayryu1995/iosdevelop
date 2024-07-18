//
//  PermissionClass.swift
//  ByahtColor
//
//  Created by jaem on 2023/09/22.
//

import Photos

class Permission {
    func checkPermissions() {

        checkCameraPermissions { [weak self] granted in
            guard granted else {
                // Handle if camera access is not granted
                return
            }
            self?.checkPhotoLibraryPermissions { granted in
                guard granted else {
                    // Handle if photo library access is not granted

                    return
                }

            }
        }
    }

    // 카메라 권한 확인 //
    func checkCameraPermissions(completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }

    // 앨범 권한 확인 //
    func checkPhotoLibraryPermissions(completion: @escaping (Bool) -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch photoAuthorizationStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        case .authorized:
            completion(true)
        case .denied, .restricted, .limited:
            completion(false)

        @unknown default:
            completion(false)
        }
    }
}
