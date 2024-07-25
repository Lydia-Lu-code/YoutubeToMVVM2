//
//  ShorstFramebottom.swift
//  YoutubeViewController
//
//  Created by Lydia Lu on 2024/4/6.
//

import UIKit

class ShortsBtnView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAccountView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView :UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = UIImage(named: "image1")
        return imgView
    }()
    
    let accountButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14) // 調整字體大小
        return btn
    }()


    let subscriptionButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .darkGray
        btn.setTitle("訂閱", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) // 設置文字前後各+5
        btn.layer.cornerRadius = 15 // 設置按鈕為橢圓形，半徑為按鈕高度的一半，假設高度是30
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14) // 調整字體大小
        btn.clipsToBounds = true // 確保按鈕邊界是圓角
        return btn
    }()
    
    lazy var accountView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(accountButton)
        stackView.addArrangedSubview(subscriptionButton)
        return stackView
    }()

    let txtLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints  = false
        lbl.text = ".txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt .txt "
        lbl.numberOfLines = 0 // 將行數設置為0以啟用自動調整高度
        lbl.textColor = .white
        return lbl
    }()
    

    let musicButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("music", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.contentHorizontalAlignment = .left // 文字靠左對齊
        return btn
    }()
    
    lazy var stackView: UIStackView = {
         let stackView = UIStackView()
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.axis = .vertical
         stackView.distribution = .fillEqually
         stackView.spacing = 8
         stackView.addArrangedSubview(accountView)
         stackView.addArrangedSubview(txtLabel)
         stackView.addArrangedSubview(musicButton)
         return stackView
     }()
 
    private func setAccountView() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 140), // 設置總高度為 140
            subscriptionButton.heightAnchor.constraint(equalToConstant: 30)

        ])
        
        // 設置 imageView 尺寸為 60x60
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // 將 imageView 設置為圓形
        imageView.layer.cornerRadius = 20 // 半徑為高度的一半，使其成為圓形
        imageView.clipsToBounds = true // 確保圖像顯示為圓形
        
        // 設置 imageView 的 contentMode
        imageView.contentMode = .scaleAspectFit
        
        

    }
    

}
