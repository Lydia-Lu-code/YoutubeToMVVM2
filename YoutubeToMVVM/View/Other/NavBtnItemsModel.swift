import UIKit
import Foundation

enum SetNavBtnItems: CaseIterable {
    case search
    case notifications
    case display

    var systemName: String {
        switch self {
        case .search:
            return "magnifyingglass"
        case .notifications:
            return "bell"
        case .display:
            return "display"
        }
    }
}

protocol NavButtonItemsDelegate: AnyObject {
    func setNavBtnItems()
    func topButtonTapped(_ sender: UIBarButtonItem)
    func presentSearchViewController()
    func presentAlertController(title: String, message: String?)
    func navigateToNotificationLogViewController()
}

class NavButtonItemsModel: NavButtonItemsDelegate {
    weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
        updateThemeAppearance(for: viewController.traitCollection.userInterfaceStyle)

    }

    
    
    
    func updateThemeAppearance(for interfaceStyle: UIUserInterfaceStyle) {
        // 根據界面風格設置導航欄外觀
        if let navigationController = viewController?.navigationController {
            let navigationBarAppearance = UINavigationBarAppearance()
            if interfaceStyle == .dark {
                // 暗黑模式
                navigationBarAppearance.backgroundColor = .black
                // 添加其他暗黑模式下的設置
            } else {
                // 淺色模式
                navigationBarAppearance.backgroundColor = .white
                // 添加其他淺色模式下的設置
            }
            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            if #available(iOS 15.0, *) {
                navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            }
        }
    }
    
    func setNavBtnItems() {
        var barButtonItems: [UIBarButtonItem] = []
        for (index, item) in SetNavBtnItems.allCases.enumerated() {
            let barButtonItem = UIBarButtonItem(image: UIImage(systemName: item.systemName),
                                                style: .plain,
                                                target: self,
                                                action: #selector(topButtonTapped(_:)))
            barButtonItem.tag = index
            barButtonItems.append(barButtonItem)
        }
        viewController?.navigationItem.setRightBarButtonItems(barButtonItems, animated: true)
    }

    @objc func topButtonTapped(_ sender: UIBarButtonItem) {
        guard let itemType = SetNavBtnItems.allCases[safe: sender.tag] else { return }
        switch itemType {
        case .search:
            presentSearchViewController()
        case .notifications:
            navigateToNotificationLogViewController()
        case .display:
            presentAlertController(title: "選取裝置", message: nil)
        }
    }

    func presentSearchViewController() {
        guard let viewController = viewController else { return }
        let searchVC = SearchVC() // 假設 SearchViewController 是您的搜索視圖控制器類
        searchVC.title = viewController.navigationItem.searchController?.searchBar.text ?? "" // 使用搜索框的文本作为标题
        viewController.navigationController?.pushViewController(searchVC, animated: true)
    }

    func presentAlertController(title: String, message: String?) {
        guard let viewController = viewController else { return }
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

    func navigateToNotificationLogViewController() {
        guard let viewController = viewController else { return }
        let notificationLogVC = NotificationLogVC()
        notificationLogVC.title = "通知"
        viewController.navigationController?.pushViewController(notificationLogVC, animated: true)
    }
    
    // 在 NavButtonItemsModel 中添加這個方法
    func handleTraitCollectionChange(previousTraitCollection: UITraitCollection?) {
        guard let viewController = viewController else { return }
        
        // 檢查主題模式是否有變更
        if previousTraitCollection?.userInterfaceStyle != viewController.traitCollection.userInterfaceStyle {
            // 更新導航欄和標籤欄外觀
            updateThemeAppearance(for: viewController.traitCollection.userInterfaceStyle)
            updateTabBarAppearance(for: viewController.traitCollection.userInterfaceStyle)
        }
    }

    // 添加更新標籤欄外觀的方法
    func updateTabBarAppearance(for interfaceStyle: UIUserInterfaceStyle) {
        if let tabBar = viewController?.tabBarController?.tabBar {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            
            if interfaceStyle == .dark {
                tabBarAppearance.backgroundColor = .black
            } else {
                tabBarAppearance.backgroundColor = .white
            }
            
            tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
    }

}

