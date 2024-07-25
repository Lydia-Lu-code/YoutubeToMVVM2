//
//  CustomTopView.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/26.
//

import UIKit

class ContentTopView: UIView {

    // MARK: - Properties

    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image1")
//        imageView.backgroundColor = .lightGray // 設定圖片背景色
        return imageView
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white // 設定文字顏色
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Lydia"
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitle("﻿@user-12345678﻿．﻿ｕ﻿瀏覽頻道﻿ ﻿>﻿ ", for: .normal)
//        button.backgroundColor = .orange
//        button.setTitleColor(.white, for: .normal) // 設定按鈕文字顏色
        return button
    }()
    
    

    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
//        stackView.spacing = 8
        return stackView
    }()

    lazy var btn1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("切換帳戶", for: .normal)
//        button.setTitleColor(.white, for: .normal) // 設定按鈕文字顏色
        button.layer.cornerRadius = 15 // 设置圆角
        button.clipsToBounds = true // 确保子视图被裁剪到圆角
//        button.sizeToFit() // 自动调整按钮大小以适应内容
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // 设置按钮内容的内边距

        return button
    }()

    lazy var btn2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("﻿Google﻿帳戶", for: .normal)
//        button.setTitleColor(.white, for: .normal) // 設定按鈕文字顏色
        button.layer.cornerRadius = 15 // 设置圆角
        button.clipsToBounds = true // 确保子视图被裁剪到圆角
//        button.sizeToFit() // 自动调整按钮大小以适应内容
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // 设置按钮内容的内边距

        return button
    }()

    lazy var btn3: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("﻿啟用無痕視窗", for: .normal)
//        button.setTitleColor(.white, for: .normal) // 設定按鈕文字顏色
        button.layer.cornerRadius = 15 // 设置圆角
        button.clipsToBounds = true // 确保子视图被裁剪到圆角
//        button.sizeToFit()  // 自动调整按钮大小以适应内容
        button.backgroundColor = .darkGray
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15) // 设置按钮内容的内边距

        return button
    }()
    

    lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup UI

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(stackView)
        containerView.addSubview(bottomStackView)

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        
        bottomStackView.addArrangedSubview(btn1)
        bottomStackView.addArrangedSubview(btn2)
        bottomStackView.addArrangedSubview(btn3)

        NSLayoutConstraint.activate([

            containerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            
            // imageView 的約束
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16), // 調整偏移量以適應 UI
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16), // 調整偏移量以適應 UI
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),

            // stackView 的約束
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: imageView.topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 70),
         

            // bottomStackView 的約束
            bottomStackView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16), // 調整偏移量以適應 UI
            bottomStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16) // 調整偏移量以適應 UI

         ])
     }

    

}

