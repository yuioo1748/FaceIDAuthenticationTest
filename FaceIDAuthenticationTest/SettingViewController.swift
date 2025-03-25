//
//  SettingViewController.swift
//  FaceIDAuthenticationTest
//
//  Created by AndyHsieh on 2025/2/25.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "設置"
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "登出", message: "您確定要登出嗎？", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "確定", style: .destructive) { _ in
            // 設置登出標記
            UserDefaults.standard.set(true, forKey: "justLoggedOut")
            
            // 跳轉到 LoginViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let navController = UINavigationController(rootViewController: loginVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
