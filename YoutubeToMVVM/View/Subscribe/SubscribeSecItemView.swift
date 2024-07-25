
import UIKit

class SubscribeSecItemView: UIView {
    
    let buttons: [UIButton] = {
        var buttonArray = [UIButton]()
        for i in 1...20 {
            let buttonWidth: CGFloat = 68 // 設置按鈕的寬度

            let button = UIButton()
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
            
            // 設置圖片的內容
            let originalImage = UIImage(named: "image2")
            let imageSize = CGSize(width: 65, height: 65) // 設置圖片大小
            let roundedImage = originalImage?.roundedImage(withSize: imageSize)
            button.setImage(roundedImage, for: .normal)

            // 設置文字的內容
            let title = "Emoji \(i)"
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.titleLabel?.textAlignment = .center

            // 設置圖片和文字的排列方式
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            
            // 設置文字的上邊距，使其顯示在圖片的下方
            let spacing: CGFloat = 15

            button.titleEdgeInsets = UIEdgeInsets(top: imageSize.height + spacing, left: -imageSize.width , bottom: 0, right: 0)
            buttonArray.append(button)
        }
        return buttonArray // 返回創建的按鈕陣列
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        for button in buttons {
            stackView.addArrangedSubview(button)
        }

        return stackView
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.setTitle("全部", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setScrollView()
        setRightBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setScrollView() {
        addSubview(scrollView)
        
        // 添加 scrollView 到父視圖
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 添加 stackView 到 scrollView 中
        scrollView.addSubview(stackView)
        
        // 添加 stackView 的尺寸約束
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -55),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func setRightBtn() {
        addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            rightButton.widthAnchor.constraint(equalToConstant: 55),
            rightButton.heightAnchor.constraint(equalToConstant: 90),
            rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            rightButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

extension UIImage {
    func roundedImage(withSize size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let roundedRect = CGRect(origin: .zero, size: size)
            UIBezierPath(roundedRect: roundedRect, cornerRadius: size.width/2).addClip()
            self.draw(in: roundedRect)
        }
    }
}

