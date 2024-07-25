//
//  SideMenuViewController.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/15.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: MenuVC.MenuOptions)
}

class MenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var delegate: MenuViewControllerDelegate?
    
    enum MenuOptions: String,CaseIterable {
        case trendingVideos = "發燒影片"
        case music = "音樂"
        case movies = "電影"
        case liveStreams = "直播"
        case gaming = "遊戲"
        case news = "新聞"
        case sports = "體育"
        case podcasts = "Podcast"
        case youTubeStudio = "YouTube 工作室"
        case youTubeMusic = "YouTube Music"
        case youTubeKids = "YouTube Kids"
        
        var imageName: String {
            switch self {
            case .trendingVideos: return "flame"
            case .music: return "music.note"
            case .movies: return "movieclapper"
            case .liveStreams: return "dot.radiowaves.left.and.right"
            case .gaming: return "gamecontroller"
            case .news: return "newspaper"
            case .sports: return "trophy"
            case .podcasts: return "antenna.radiowaves.left.and.right"
            case .youTubeStudio: return " "
            case .youTubeMusic: return " "
            case .youTubeKids: return " "

            }
        }
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    let greyColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth * 0.75
        view.frame = CGRect(x: 0, y: 0, width: width, height: UIScreen.main.bounds.height)

        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = greyColor

        
        // 添加手勢辨識器
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeDownGesture.direction = .down
        self.view.addGestureRecognizer(swipeDownGesture)
        
        // 添加背景視圖
        let backgroundView = UIView(frame: self.view.bounds)
//        backgroundView.backgroundColor = .clear
        self.view.insertSubview(backgroundView, at: 0)
        
        // 添加點擊手勢辨識器
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // 添加返回键
        let backButton = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // 手勢辨識器的動作處理方法
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        // 檢查手勢的方向是否向下
        if gesture.direction == .down {
            // 移除選單視圖
            self.dismiss(animated: true, completion: nil)
        }
    }

    // 點擊手勢辨識器的動作處理方法
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        // 移除選單視圖
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.bounds.size.width, height: 500)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.backgroundColor = greyColor
        cell.contentView.backgroundColor = greyColor
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: item)
    }

}
