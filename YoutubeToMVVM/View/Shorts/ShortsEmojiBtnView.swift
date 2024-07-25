//
//  EmojiButtonView.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/6.
//

import UIKit
import Foundation

class ShortsEmojiBtnView: UIView {
    
    var titleText: [String] = ["Int", "不喜歡", "Int", "分享", "Remix", "imgName"]
    var sfSymbols: [String] = ["hand.thumbsup.fill", "hand.thumbsdown.fill", "person.2.fill", "square.and.arrow.up.fill", "wand.and.stars", "photo.fill"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStackView() {
        
        // 创建垂直的 stackView
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        addSubview(stackView)
        
        // 添加约束
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 添加六個按鈕到 stackView 中
        for i in 0..<6 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            // 设置 SF Symbols 和文字到按钮的标题中，并在它们之间换行
            let symbol = UIImage(systemName: sfSymbols[i])
            let title = titleText[i]
            
            // 使用 NSMutableAttributedString 来设置按钮的标题
            let attributedString = NSMutableAttributedString()
            
            // 添加 SF Symbol
            if let symbol = symbol {
                let symbolAttachment = NSTextAttachment(image: symbol)
                let symbolString = NSAttributedString(attachment: symbolAttachment)
                attributedString.append(symbolString)
            }
            
            // 添加换行符
            attributedString.append(NSAttributedString(string: "\n"))
            
            // 添加文字
            attributedString.append(NSAttributedString(string: title))
            
            // 设置按钮的富文本标题
            button.setAttributedTitle(attributedString, for: .normal)
            button.titleLabel?.numberOfLines = 2
            button.titleLabel?.textAlignment = .center
            
            // 添加按钮到 stackView 中
            stackView.addArrangedSubview(button)
            
            // 添加按钮的尺寸约束
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
    }
}






