//
//  MainViewController.swift
//  FaceIDAuthenticationTest
//
//  Created by AndyHsieh on 2025/2/24.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var sayHiLabel: UILabel!
    
    @IBOutlet weak var eMailBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var customerServiceBtn: UIButton!
    @IBOutlet weak var emojiBtn: UIButton!
    @IBOutlet weak var tvBtn: UIButton!
    @IBOutlet weak var shopBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent // 白色文字
            // 或者 .darkContent 黑色文字
        }
    
    // 新增 YouTube 按鈕
    private let youtubeButton = UIButton(type: .system)
    
    var userNameText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    private func setupUI() {
        sayHiLabel.text = "Hello, \(userNameText ?? "User")!"
        
        // 設置 SF Symbols 圖標
        configureButton(eMailBtn, symbolName: "envelope.fill")
        configureButton(phoneBtn, symbolName: "phone.fill")
        configureButton(customerServiceBtn, symbolName: "person.line.dotted.person.fill")
        configureButton(emojiBtn, symbolName: "face.smiling.fill")
        configureButton(tvBtn, symbolName: "tv.fill")
        configureButton(shopBtn, symbolName: "cart.fill")
        
        // 配置 YouTube 按鈕
        youtubeButton.setTitle("前往 YouTube 頻道", for: .normal)
        youtubeButton.frame = CGRect(x: 50, y: 500, width: 300, height: 50)
        youtubeButton.backgroundColor = .systemRed // YouTube 紅色
        youtubeButton.setTitleColor(.white, for: .normal)
        youtubeButton.layer.cornerRadius = 10
        youtubeButton.addTarget(self, action: #selector(openYouTubeChannel), for: .touchUpInside)
        view.addSubview(youtubeButton)
        
    }
    
    private func configureButton(_ button: UIButton, symbolName: String) {
        // 使用 SF Symbols
        if let symbolImage = UIImage(systemName: symbolName) {
            // 調整圖標大小
            let configuration = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium) // 設置大小為 40 點
            let largeImage = symbolImage.withConfiguration(configuration).withTintColor(.black, renderingMode: .alwaysOriginal)
            button.setImage(largeImage, for: .normal)
        }
        
        // 移除文字
        button.setTitle("", for: .normal)
        
        // 調整圖片顯示
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        // 如果 Storyboard 未設置大小，這裡強制設置（可選）
        if button.frame.size == .zero {
            button.frame.size = CGSize(width: 100, height: 100)
        }
    }
    
    
    @objc private func openYouTubeChannel() {
        //            let channelID = "UCm5t5WQgyp5h5RUFRR4eJzQ" // 替換為你的目標頻道 ID
        //            let youtubeAppURL = URL(string: "youtube://channel/\(channelID)")!
        //            let youtubeWebURL = URL(string: "https://www.youtube.com/channel/\(channelID)")!
        
        
        let channelHandle = "@addwii1650" // 替換為你的目標頻道 ID
        let youtubeAppURL = URL(string: "youtube://\(channelHandle)")!
        let youtubeWebURL = URL(string: "https://www.youtube.com/\(channelHandle)")!
        
        if UIApplication.shared.canOpenURL(youtubeAppURL) {
            // 打開 YouTube App
            UIApplication.shared.open(youtubeAppURL, options: [:]) { success in
                if !success {
                    print("無法打開 YouTube App")
                }
            }
        } else {
            // 若未安裝 YouTube App，fallback 到 Safari
            UIApplication.shared.open(youtubeWebURL, options: [:]) { success in
                if !success {
                    print("無法打開 YouTube 網頁")
                }
            }
        }
    }
}
