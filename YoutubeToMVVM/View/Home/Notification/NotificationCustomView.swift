import UIKit

class NotificationCustomView: UIView {
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        let title = "啟用通知功能"
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        let width = title.width(withConstrainedHeight: 50, font: UIFont.systemFont(ofSize: 16, weight: .semibold)) + 20 // 加上一些額外的間距
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        return button
    }()
    
    private let extraButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setViews() {
        addSubview(leftImageView)
        addSubview(label1)
        addSubview(label2)
        addSubview(actionButton)
        addSubview(extraButton)
        
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        extraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 左邊 UIImageView
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftImageView.topAnchor.constraint(equalTo: topAnchor),
            leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftImageView.widthAnchor.constraint(equalToConstant: 60),
            
            // 上面的 UILabel
            label1.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            label1.topAnchor.constraint(equalTo: topAnchor),
            label1.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // 下面的 UILabel
            label2.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 4),
            label2.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // Button
            actionButton.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            actionButton.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 8),
            
            // 右邊的按鈕
            extraButton.widthAnchor.constraint(equalToConstant: 40),
            extraButton.heightAnchor.constraint(equalToConstant: 40),
            extraButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            extraButton.topAnchor.constraint(equalTo: topAnchor),
        ])
            // 計算 customView 的高度，等於最下面的按鈕元件的高度 + 20
            let buttonHeight: CGFloat = 40
            let customViewHeight = buttonHeight + 60
            NSLayoutConstraint.activate([
                heightAnchor.constraint(equalToConstant: customViewHeight)
            
        ])
    }
    
    func configure(image: UIImage?, text1: String, text2: String, buttonText: String) {
        leftImageView.image = image
        label1.text = text1
        label2.text = text2
        actionButton.setTitle(buttonText, for: .normal)
    }
}

