//
//  KeychainManager.swift
//  FaceIDAuthenticationTest
//
//  Created by AndyHsieh on 2025/2/24.
//

import Security
import Foundation

struct KeychainManager {
    private static let accountKey = "com.demo.faceid.account"
    private static let passwordKey = "com.demo.faceid.password"
    
    // 儲存帳密
    static func saveCredentials(username: String, password: String) {
        let usernameData = Data(username.utf8)
        let passwordData = Data(password.utf8)
        
        // 儲存帳號
        let usernameQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: accountKey,
            kSecValueData: usernameData
        ] as CFDictionary
        SecItemDelete(usernameQuery)
        SecItemAdd(usernameQuery, nil)
        
        // 儲存密碼
        let passwordQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: passwordKey,
            kSecValueData: passwordData
        ] as CFDictionary
        SecItemDelete(passwordQuery)
        SecItemAdd(passwordQuery, nil)
    }
    
    // 提取帳密
    static func getCredentials() -> (username: String, password: String)? {
        // 提取帳號
        let usernameQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: accountKey,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        var usernameItem: AnyObject?
        SecItemCopyMatching(usernameQuery, &usernameItem)
        guard let usernameData = usernameItem as? Data,
              let username = String(data: usernameData, encoding: .utf8) else { return nil }
        
        // 提取密碼
        let passwordQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: passwordKey,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        var passwordItem: AnyObject?
        SecItemCopyMatching(passwordQuery, &passwordItem)
        guard let passwordData = passwordItem as? Data,
              let password = String(data: passwordData, encoding: .utf8) else { return nil }
        
        return (username, password)
    }
    
    // 檢查是否已有帳密
    static func hasCredentials() -> Bool {
        return getCredentials() != nil
    }
    
    // 清除帳密
    static func clearCredentials() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: accountKey
        ] as CFDictionary
        SecItemDelete(query)
        
        let passwordQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: passwordKey
        ] as CFDictionary
        SecItemDelete(passwordQuery)
    }
}
