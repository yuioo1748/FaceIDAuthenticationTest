//
//  FaceIDManager.swift
//  FaceIDAuthenticationTest
//
//  Created by AndyHsieh on 2025/2/24.
//

import LocalAuthentication

class FaceIDManager {
    func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "請使用 Face ID 進行身份驗證"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError?.localizedDescription)
                    }
                }
            }
        } else {
            let message: String
            if let err = error {
                switch err.code {
                case LAError.biometryNotEnrolled.rawValue:
                    message = "請先在設定中註冊 Face ID"
                case LAError.biometryNotAvailable.rawValue:
                    message = "此設備不支援 Face ID"
                default:
                    message = "無法使用 Face ID: \(err.localizedDescription)"
                }
            } else {
                message = "未知錯誤"
            }
            completion(false, message)
        }
    }
}
