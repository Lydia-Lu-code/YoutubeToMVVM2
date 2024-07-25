//
//  UIViewController+Additions.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/6/1.
//

import Foundation
import UIKit

extension UIViewController {
    func parentViewController () -> UIViewController? {
        // 從當前視圖控制器的 next 開始向上查找
        var nextResponder = self.next
        while let responder = nextResponder {
            // 如果找到 UIViewController 實例，返回它
            if let viewController = responder as? UIViewController {
                return viewController
            }
            // 否則，繼續遍歷下一個響應者
            nextResponder = responder.next
        }
        // 如果沒有找到 UIViewController 實例，返回 nil
        return nil
    }
    
}
