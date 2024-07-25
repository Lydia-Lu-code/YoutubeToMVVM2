//
//  SearchViewController.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/17.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建搜索框
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "搜索"
        navigationItem.titleView = searchController.searchBar
        
        // 创建搜索按钮
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
        
        // 隐藏返回按钮
        navigationItem.hidesBackButton = true
        // 创建自定义的返回按钮
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func searchButtonTapped() {
        // 搜索按钮被点击时执行的操作
        // 在这里添加搜索按钮点击后的逻辑
    }

    @objc func backButtonTapped() {
        // 返回按钮被点击时执行的操作
        // 在这里添加返回按钮点击后的逻辑
        navigationController?.popViewController(animated: true)
    }

}
