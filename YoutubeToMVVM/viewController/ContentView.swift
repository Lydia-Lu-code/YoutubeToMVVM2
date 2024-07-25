//
//  ContentView.swift
//  YoutubeToMVVM
//
//  Created by Lydia Lu on 2024/6/12.
//

import UIKit

class ContentView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // 計算所有子視圖的總高度
        var totalHeight: CGFloat = 0
        for subview in subviews {
            totalHeight += subview.frame.height
        }
        // 更新scrollView的contentSize
        if let scrollView = superview as? UIScrollView {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: totalHeight)
        }
    }
}
