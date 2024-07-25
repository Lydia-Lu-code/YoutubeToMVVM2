import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setViewControllers()
    }

    private func setupAppearance() {
        // 設置 UINavigationBar 外觀
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(named: "NavigationBarColor") // 設置背景顏色
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        // 設置 UITabBar 外觀
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "TabBarColor") // 設置背景顏色

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }

    private func setViewControllers() {
        // HomeVC
        let homeVC = HomeViewController(vcType: .home)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        
        // ShortsVC
        let shortsVC = ShortsTableViewController()
        let shortsNav = UINavigationController(rootViewController: shortsVC)
        shortsNav.tabBarItem = UITabBarItem(title: "Shorts", image: nil, tag: 1)
        
        // AddVC
        let addVC = AddVC()
        let addNav = UINavigationController(rootViewController: addVC)
        addNav.tabBarItem = UITabBarItem(title: "Add", image: nil, tag: 2)
        
        // SubscribeVC
        let subscribeVC = SubscribeViewController(vcType: .subscribe)
        let subscribeNav = UINavigationController(rootViewController: subscribeVC)
        subscribeNav.tabBarItem = UITabBarItem(title: "Subscribe", image: nil, tag: 3)
        
        // ContentVC
        let contentTableViewController = ContentTableViewController()
        let contentNav = UINavigationController(rootViewController: contentTableViewController)
        contentNav.tabBarItem = UITabBarItem(title: "Content", image: nil, tag: 4)
        
        // 設置標籤欄控制器的所有子視圖控制器
        self.viewControllers = [homeNav, shortsNav, addNav, subscribeNav, contentNav]
    }
}

