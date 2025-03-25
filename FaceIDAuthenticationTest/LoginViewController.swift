//
//  LoginViewController.swift
//  FaceIDAuthenticationTest
//
//  Created by AndyHsieh on 2025/2/24.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate {
    // UI 元素
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let faceAuthenticationButton = UIButton(type: .system)
    
    private let faceIDManager = FaceIDManager()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // 這樣設置狀態欄文字為白色
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 檢查是否首次啟動或重新安裝
        if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            KeychainManager.clearCredentials() // 清除 Keychain
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore") // 設置標記
        }
        
        // 檢查是否剛登出，若不是且有帳密則觸發 Face ID
        if !UserDefaults.standard.bool(forKey: "justLoggedOut") && KeychainManager.hasCredentials() {
            authenticateWithFaceID()
        }
        UserDefaults.standard.set(false, forKey: "justLoggedOut")
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // 設置 UI
    private func setupUI() {
        view.backgroundColor = .white
        
        usernameTextField.placeholder = "帳號"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.frame = CGRect(x: 50, y: 200, width: 300, height: 40)
        view.addSubview(usernameTextField)
        
        passwordTextField.placeholder = "密碼"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.frame = CGRect(x: 50, y: 250, width: 300, height: 40)
        view.addSubview(passwordTextField)
        
        loginButton.setTitle("登入", for: .normal)
        loginButton.frame = CGRect(x: 50, y: 310, width: 100, height: 40)
        loginButton.backgroundColor = .systemBlue // 添加背景顏色（藍色）
        loginButton.setTitleColor(.white, for: .normal) // 文字顏色改為白色，對比更明顯
        loginButton.layer.cornerRadius = 10 // 可選：圓角效果
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)
        
        faceAuthenticationButton.setTitle("生物驗證登入", for: .normal)
        faceAuthenticationButton.frame = CGRect(x: 200, y: 310, width: 150, height: 40)
        faceAuthenticationButton.backgroundColor = .systemBlue // 添加背景顏色（藍色）
        faceAuthenticationButton.setTitleColor(.white, for: .normal) // 文字顏色改為白色，對比更明顯
        faceAuthenticationButton.layer.cornerRadius = 10 // 可選：圓角效果
        faceAuthenticationButton.addTarget(self, action: #selector(authenticateWithFaceID), for: .touchUpInside)
        view.addSubview(faceAuthenticationButton)
        
    }
    
    // 密碼登入按鈕
    @objc private func loginButtonTapped() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "請輸入帳號和密碼")
            return
        }
        
        
        // Face ID 成功，儲存帳密並登入
        KeychainManager.saveCredentials(username: username, password: password)
        self.performLogin(username: username, password: password)
        
    }
    
    // Face ID 驗證（後續登入）
    @objc private func authenticateWithFaceID() {
        faceIDManager.authenticateUser { success, errorMessage in
            if success {
                // 從 Keychain 取出帳密並登入
                guard let (username, password) = KeychainManager.getCredentials() else {
                    self.showAlert(message: "無法獲取儲存的帳密")
                    return
                }
                self.performLogin(username: username, password: password)
            } else {
                self.showAlert(message: "Face ID 驗證失敗：\(errorMessage ?? "未知錯誤")，請使用密碼登入")
            }
        }
    }
    
    // 模擬後端登入
    private func performLogin(username: String, password: String) {
        // 這裡模擬檢查帳密，實際應呼叫後端 API
        if username == "user555" && password == "pass123" {
            DispatchQueue.main.async {
                // 更新 UI
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                mainVC.userNameText = username // 傳遞使用者名稱
                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        } else {
            KeychainManager.clearCredentials() // 失敗時清除無效帳密
            showAlert(message: "登入失敗，帳號或密碼錯誤")
        }
    }
    
    // 顯示提示
    private func showAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確定", style: .default))
            self.present(alert, animated: true)
        }
    }
}
