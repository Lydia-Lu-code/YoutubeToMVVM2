
import UIKit

class ShortsCollectionViewCell: UICollectionViewCell {
    
    public static let cellIdentifier = "ShortsCollectionViewCell"
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill

        return button
    }()
    
    // 添加圖像視圖
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "ellipsis") // 使用三個點符號作為示意圖
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image // 返回創建的圖像視圖實例
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "Placeholder"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var keywords: [String] = [""]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButton()
    }
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setButton()
    }

    public func setButton() {
        contentView.addSubview(button)
        button.addSubview(imageView)
        button.addSubview(titleLabel)
        
        // 設置圖像視圖和標籤的約束
        NSLayoutConstraint.activate([
            // 圖像視圖約束
            imageView.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -17),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            
            // 標籤約束
            titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: 40), // 設置標籤的高度為40
            
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])


            
        // 添加按鈕點擊事件處理程序
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    @objc private func buttonTapped() {
        print("SCVC Button tapped with keywords: \(keywords)")
    }
    


    
    public func setImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                self.button.setImage(image, for: .normal)
            }
        }.resume()
    }

    


    
    public func setKeywords(_ keywords: [String]) {
        self.keywords = keywords
    }
}


