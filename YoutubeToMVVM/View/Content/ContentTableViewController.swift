//
//  YourContentViewController.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/5.
//

import UIKit

class ContentTableViewController: UITableViewController {
    
    var navButtonItemsModel: NavButtonItemsModel!
    var conViewModel1 = VideoViewModel()
    var conViewModel2 = VideoViewModel()
    
    lazy var contentTopView: ContentTopView = {
        let view = ContentTopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionHeaderTopPadding = 0
        
        // 設置 dataLoadedCallback
        conViewModel1.dataLoadedCallback = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        conViewModel2.dataLoadedCallback = { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        conViewModel1.loadShortsCell(withQuery: "2024 韓 團綜", for: .content)
        conViewModel2.loadShortsCell(withQuery: "2023 年末舞台", for: .content)
        
        // 初始化 navButtonItemsModel 並設置導航按鈕
        navButtonItemsModel = NavButtonItemsModel(viewController: self)
        navButtonItemsModel.setNavBtnItems()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 通知 NavButtonItemsModel traitCollection 改變
        navButtonItemsModel?.handleTraitCollectionChange(previousTraitCollection: previousTraitCollection)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 || section == 2 ? 1 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else {
            return UITableViewCell()
        }
        
        if indexPath.section == 1 {
            if conViewModel1.data.value.count > 0 {
                let items = Array(conViewModel1.data.value.prefix(16))
                cell.configure(with: items)
            }
        } else if indexPath.section == 2 {
            if conViewModel2.data.value.count > 0 {
                let items = Array(conViewModel2.data.value.prefix(16))
                cell.configure(with: items)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            
            // Add your custom content here
            let contentTopView = ContentTopView()
            contentTopView.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(contentTopView)
            
            NSLayoutConstraint.activate([
                contentTopView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                contentTopView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                contentTopView.topAnchor.constraint(equalTo: headerView.topAnchor),
                contentTopView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
            ])
            
            return headerView
        } else {
            let headerView = ContentHeaderView()
            headerView.delegate = self
            
            // SF Symbols array
            let sfSymbols = [
                "eye.fill",        // 觀看歷史
                "list.bullet",     // 播放清單
                "film.fill",       // 你的影片
                "arrow.down.circle", // 已下載的內容
                "tv.fill",         // 你的電影
                "crown.fill",      // Premium 會員福利
                "clock.fill",      // 已觀看時間
                "bubble.left.fill" // 說明和意見回饋
            ]
            
            // Create attributed string with SF Symbol and text
            func attributedTitle(title: String, symbol: String?) -> NSAttributedString {
                let completeString = NSMutableAttributedString()
                
                if let symbol = symbol, let symbolImage = UIImage(systemName: symbol) {
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = symbolImage.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
                    
                    let imageString = NSAttributedString(attachment: imageAttachment)
                    completeString.append(imageString)
                }
                
                let titleString = NSAttributedString(string: " \(title)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                completeString.append(titleString)
                return completeString
            }
            
            // Set different button titles and symbols for each section
            switch section {
            case 1:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "觀看歷史", symbol: nil), for: .normal)
                headerView.rightButton.setTitle("查看全部", for: .normal)
            case 2:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "播放清單", symbol: nil), for: .normal)
                headerView.rightButton.setTitle("查看全部", for: .normal)
            case 3:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "你的影片", symbol: sfSymbols[2]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            case 4:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "已下載的內容", symbol: sfSymbols[3]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            case 5:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "你的電影", symbol: sfSymbols[4]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            case 6:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "Premium 會員福利", symbol: sfSymbols[5]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            case 7:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "已觀看時間", symbol: sfSymbols[6]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            case 8:
                headerView.leftButton.setAttributedTitle(attributedTitle(title: "說明和意見回饋", symbol: sfSymbols[7]), for: .normal)
                headerView.rightButton.setTitle(" ", for: .normal)
            default:
                break
            }
            return headerView
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 150 : 45
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

extension ContentTableViewController: ContentHeaderViewDelegate {
    func doSegueAction() {
        print("CTVC 成功")
    }
}


//
////
////  YourContentViewController.swift
////  YoutubeViewController
////
////  Created by Lydia Lu on 2024/4/5.
////
//
//import UIKit
//
//class ContentTableViewController: UITableViewController, NavButtonItemsDelegate {
//    
//    
//    var navButtonItemsModel: NavButtonItemsModel!
//    var conViewModel1 = VideoViewModel()
//    var conViewModel2 = VideoViewModel()
//    
//    lazy var contentTopView: ContentTopView = {
//        let view = ContentTopView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
//        tableView.sectionHeaderHeight = UITableView.automaticDimension
//        tableView.estimatedSectionHeaderHeight = 0
//        tableView.sectionHeaderTopPadding = 0
//        
//        // 設置 dataLoadedCallback
//        conViewModel1.dataLoadedCallback = { [weak self] _ in
//            self?.tableView.reloadData()
//        }
//        
//        conViewModel2.dataLoadedCallback = { [weak self] _ in
//            self?.tableView.reloadData()
//        }
//        
//        conViewModel1.loadShortsCell(withQuery: "2024 韓 團綜", for: .content)
//        conViewModel2.loadShortsCell(withQuery: "2023 年末舞台", for: .content)
//        
//        // 初始化 barButtonItemsModel 並設置代理
//        navButtonItemsModel = NavButtonItemsModel(viewController: self)
//        navButtonItemsModel.setNavBtnItems()
//        
//        
//        // 設置 tabBar 的背景顏色
//        updateTabBarAppearance()
//        // 設置導航條背景顏色
//        updateNavBarAppearance()
//    }
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//        // 通知 NavButtonItemsModel traitCollection 改變
//                navButtonItemsModel?.handleTraitCollectionChange(previousTraitCollection: previousTraitCollection)
//
//        
//        if previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle {
//            updateTabBarAppearance()
//            updateNavBarAppearance()
//        }
//    }
//    
//    private func updateTabBarAppearance() {
//        if let tabBar = self.tabBarController?.tabBar {
//            let tabBarAppearance = UITabBarAppearance()
//            tabBarAppearance.configureWithOpaqueBackground()
//            
//            if traitCollection.userInterfaceStyle == .dark {
//                tabBarAppearance.backgroundColor = .black
//            } else {
//                tabBarAppearance.backgroundColor = .white
//            }
//            
//            tabBar.standardAppearance = tabBarAppearance
//            if #available(iOS 15.0, *) {
//                tabBar.scrollEdgeAppearance = tabBarAppearance
//            }
//        }
//    }
//    
//    private func updateNavBarAppearance() {
//        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        
//        if traitCollection.userInterfaceStyle == .dark {
//            appearance.backgroundColor = .black
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        } else {
//            appearance.backgroundColor = .white
//            appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        }
//        
//        navigationBar.standardAppearance = appearance
//        if #available(iOS 15.0, *) {
//            navigationBar.scrollEdgeAppearance = appearance
//        }
//        
//        // 設置導航按鈕顏色
//        if let leftBarButton = navigationItem.leftBarButtonItem {
//            leftBarButton.tintColor = appearance.titleTextAttributes[.foregroundColor] as? UIColor
//        }
//        if let rightBarButton = navigationItem.rightBarButtonItem {
//            rightBarButton.tintColor = appearance.titleTextAttributes[.foregroundColor] as? UIColor
//        }
//    }
//    
//    func setNavBtnItems() {
//        navButtonItemsModel.setNavBtnItems()
//    }
//    
//    func topButtonTapped(_ sender: UIBarButtonItem) {
//        navButtonItemsModel.topButtonTapped(sender)
//    }
//    
//    func presentSearchViewController() {
//        navButtonItemsModel.presentSearchViewController()
//    }
//    
//    func presentAlertController(title: String, message: String?) {
//        navButtonItemsModel.presentAlertController(title: title, message: message)
//    }
//    
//    func navigateToNotificationLogViewController() {
//        navButtonItemsModel.navigateToNotificationLogViewController()
//    }
//    
//    
//    // MARK: - Table view data source
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 9 // 5個部分
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 1 || section == 2 ? 1 : 0
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath) as? ContentTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        if indexPath.section == 1 {
//            if conViewModel1.data.value.count > 0 {
//                let items = Array(conViewModel1.data.value.prefix(16))
////                print("CTVC cellForRowAt.item1 == \(items)")
//                cell.configure(with: items)
//            }
//        } else if indexPath.section == 2 {
//            if conViewModel2.data.value.count > 0 {
//                let items = Array(conViewModel2.data.value.prefix(16))
////                print("CTVC cellForRowAt.item1 == \(items)")
//                cell.configure(with: items)
//            }
//        }
//        return cell
//    }
//    
//        
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//            if section == 0 {
//                let headerView = UIView()
//                
//                // Add your custom content here
//                let contentTopView = ContentTopView()
//                contentTopView.translatesAutoresizingMaskIntoConstraints = false
////                contentTopView.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
//                headerView.addSubview(contentTopView)
//                
//                NSLayoutConstraint.activate([
//                    contentTopView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
//                    contentTopView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
//                    contentTopView.topAnchor.constraint(equalTo: headerView.topAnchor),
//                    contentTopView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
//                ])
//                
//                return headerView
//            } else {
//                let headerView = ContentHeaderView()
//                headerView.delegate = self
//                
//                // SF Symbols array
//                let sfSymbols = [
//                    "eye.fill",        // 觀看歷史
//                    "list.bullet",     // 播放清單
//                    "film.fill",       // 你的影片
//                    "arrow.down.circle", // 已下載的內容
//                    "tv.fill",         // 你的電影
//                    "crown.fill",      // Premium 會員福利
//                    "clock.fill",      // 已觀看時間
//                    "bubble.left.fill" // 說明和意見回饋
//                ]
//                
//                // Create attributed string with SF Symbol and text
//                func attributedTitle(title: String, symbol: String?) -> NSAttributedString {
//                    let completeString = NSMutableAttributedString()
//                    
//                    if let symbol = symbol, let symbolImage = UIImage(systemName: symbol) {
//                        let imageAttachment = NSTextAttachment()
//                        imageAttachment.image = symbolImage.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
//                        
//                        let imageString = NSAttributedString(attachment: imageAttachment)
//                        completeString.append(imageString)
//                    } else {
////                        print("CTVC No symbol for title: \(title)")
//                    }
//                    
//                    let titleString = NSAttributedString(string: " \(title)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
//                    completeString.append(titleString)
//                    return completeString
//                }
//                
//                // Set different button titles and symbols for each section
//                switch section {
//                case 1:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "觀看歷史", symbol: nil), for: .normal)
//                    headerView.rightButton.setTitle("查看全部", for: .normal)
//                case 2:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "播放清單", symbol: nil), for: .normal)
//                    headerView.rightButton.setTitle("查看全部", for: .normal)
//                case 3:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "你的影片", symbol: sfSymbols[2]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                case 4:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "已下載的內容", symbol: sfSymbols[3]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                case 5:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "你的電影", symbol: sfSymbols[4]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                case 6:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "Premium 會員福利", symbol: sfSymbols[5]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                case 7:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "已觀看時間", symbol: sfSymbols[6]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                case 8:
//                    headerView.leftButton.setAttributedTitle(attributedTitle(title: "說明和意見回饋", symbol: sfSymbols[7]), for: .normal)
//                    headerView.rightButton.setTitle(" ", for: .normal)
//                default:
//                    break
//                }
//                return headerView
//            }
//        }
//        
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return section == 0 ? 150 : 45
//    }
//        
//        // 設置 cell 的高度
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 160
//        }
//    }
//
//extension ContentTableViewController:ContentHeaderViewDelegate {
//    func doSegueAction() {
//        print("CTVC 成功")
//    }
//    
//}
//
