
import UIKit

class NotificationLogVC: UIViewController {

    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 水平滾動
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false // 隱藏水平滾動條
        return collectionView
    }()
    
    private let buttonCellIdentifier = "NotificationTopButtonCollectionCell"
    
    private let customView: NotificationCustomView = {
        let view = NotificationCustomView()
        // 設置自定義視圖的其他屬性
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        // 設置 tableView 的其他屬性
        return tableView
    }()
    
    let buttonTitles = ["﻿全部","「提及」的通知"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .systemBackground

         // 設置標題
         title = "通知"

        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self


        
        // 添加 collectionView 到 ViewController 的 view 中
        view.addSubview(collectionView)
        
        // 添加自定義視圖到 ViewController 的 view 中
        view.addSubview(customView)
        
        // 添加 tableView 到 ViewController 的 view 中
        view.addSubview(tableView)
        
        // 約束設置
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        customView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
    
            
            // collectionView 約束
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 40), // 高度設置
            
 
            customView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.heightAnchor.constraint(equalToConstant: 80),
            
            // tableView 的約束
            tableView.topAnchor.constraint(equalTo: customView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)


        ])
        
        // Configure the CustomView
        let image = UIImage(systemName: "bell")?.withTintColor(.gray, renderingMode: .alwaysOriginal)

        customView.configure(image: image, text1: "﻿別錯過新影片", text2: "絕不錯過訂閱頻道推出的最新影片", buttonText: "啟用通知功能")


        
        // 註冊 cell
        collectionView.register(NotificationTopButtonCollectionCell.self, forCellWithReuseIdentifier: buttonCellIdentifier)
        
        // 註冊 tableView 的 cell
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: "NotificationTableViewCell")
        
        let displayButton = UIBarButtonItem(image: UIImage(systemName: "display.2"), style: .plain, target: self, action: #selector(playerButtonTapped))
//        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreButtonTapped))
        navigationItem.rightBarButtonItems = [moreButton, searchButton, displayButton]

    }
    
    @objc func searchButtonTapped() {
        presentSearchViewController()
    }

    @objc func playerButtonTapped() {
        presentAlertController(title: "﻿選取裝置", message: nil)
    }
    
    @objc func moreButtonTapped() {
        print("Not 實現更多按鈕的功能")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 根據當前的界面風格設置背景色
        if traitCollection.userInterfaceStyle == .dark {
            view.backgroundColor = .black
        } else {
            view.backgroundColor = .white
        }
    }

    private func presentAlertController(title: String, message: String?) {
        guard let viewController = findViewController() else {
            print("Not 無法找到視圖控制器")
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        // 設置標題文字左對齊
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = NSTextAlignment.left
        let titleAttributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        alertController.setValue(titleAttributedString, forKey: "attributedTitle")

        alertController.addAction(UIAlertAction(title: "透過電視代碼連結", style: .default, handler: { (_) in
            // buttonLeft 的處理代碼
        }))

        alertController.addAction(UIAlertAction(title: "了解詳情", style: .default, handler: { (_) in
            // buttonMid 的處理代碼
        }))

        // 設置選項文字靠左對齊
        for action in alertController.actions {
            action.setValue(NSTextAlignment.left.rawValue, forKey: "titleTextAlignment")
        }

        viewController.present(alertController, animated: true, completion: nil)
    }

    func presentSearchViewController() {
        guard let viewController = findViewController() else {
            print("Not 無法找到視圖控制器")
            return
        }
        
        let searchVC = SearchVC() // 假設 SearchViewController 是您的搜索視圖控制器類
        searchVC.title = navigationItem.searchController?.searchBar.text ?? "" // 使用搜索框的文本作为标题
        viewController.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private func findViewController() -> UIViewController? {
        if let viewController = self.next as? UIViewController {
            return viewController
        } else {
            var nextResponder = self.next
            while let responder = nextResponder {
                if let viewController = responder as? UIViewController {
                    return viewController
                }
                nextResponder = responder.next
            }
        }
        return nil
    }
    
    // MARK: - UICollectionViewDataSource
}
extension NotificationLogVC: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 2 // 填入你的數據源計算
        }
  
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: buttonCellIdentifier, for: indexPath) as! NotificationTopButtonCollectionCell
            cell.configure(title: buttonTitles[indexPath.item], backgroundColor: .darkGray) // 根據陣列中的標題設置按鈕
            return cell
        }
        
}

extension NotificationLogVC: UICollectionViewDelegateFlowLayout {
    // 修改部分：將 sizeForItemAt 方法整合到 UICollectionViewDelegateFlowLayout 中
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = buttonTitles[indexPath.item]
        let width = title.count * 22 // 你可以根據需要自行調整乘數
        let height: CGFloat = 20
        let verticalSpacing: CGFloat = 20
        
        return CGSize(width: CGFloat(width), height: height + verticalSpacing)
    }
}


    // MARK: - UITableViewDataSource

extension NotificationLogVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 兩個 section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 11 // 第一個 section 有 11 個 cell
        } else {
            return 3 // 第二個 section 有 3 個 cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        
        // 這裡使用你的圖片名稱來設置圖片
        let image = UIImage(named: "image1")
        
        cell.configure(image: image, title: "This is a long text for testing three lines in the title label. This is a long text for testing three lines in the title label. This is a long text for testing three lines in the title label.", subtitle: "3天前")
            
        
        // 設置 cell 的內容
//        cell.configure(image: image, title: "Title \(indexPath.row + 1)", subtitle: "3天前")
        
        return cell
    }
    

    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 10, width: tableView.frame.width - 30, height: 20))
            
            titleLabel.text = (section == 0) ? "本週" : "較舊"
    
            headerView.addSubview(titleLabel)
    
            return headerView
        }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
//        return max(60, UITableView.automaticDimension)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 點擊 cell 的動作
        print("Not Did select row at: \(indexPath.row)")
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.width)
    }
}

