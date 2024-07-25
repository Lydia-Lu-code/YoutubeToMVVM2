import UIKit

protocol ButtonCollectionCellDelegate: AnyObject {
    var buttonTitles: [String] { get }
    func didTapButton()
}

class ButtonCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var dataSource: ButtonCollectionCellDelegate?
    weak var delegate: ButtonCollectionCellDelegate?
    
    static let identifier = "ButtonCollectionViewCell"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ButtonCollectionViewButtonCell.self, forCellWithReuseIdentifier: ButtonCollectionViewButtonCell.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 50) // 根據需要調整高度
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.buttonTitles.count ?? 0
        //        return buttonTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewButtonCell.identifier, for: indexPath) as? ButtonCollectionViewButtonCell else {
            fatalError("Failed to dequeue ButtonCollectionViewButtonCell")
        }
        
        let title = dataSource?.buttonTitles[indexPath.item] ?? ""
        cell.button.setTitle(title, for: .normal)
        cell.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        // 設置按鈕的樣式
        cell.button.backgroundColor = UIColor.darkGray // 預設灰色背景
        cell.button.setTitleColor(UIColor.white, for: .normal) // 預設白色文字
        cell.button.titleLabel?.font = UIFont.systemFont(ofSize: 14) // 按鈕字體大小
        
        if let buttonTitles = dataSource?.buttonTitles, indexPath.item == buttonTitles.count - 1 {
            // 如果是最後一個按鈕，則設置特殊樣式
            cell.button.backgroundColor = UIColor.clear // 透明背景
            cell.button.setTitleColor(UIColor.blue, for: .normal) // 藍色文字
            cell.button.titleLabel?.font = UIFont.systemFont(ofSize: 13) // 縮小字體大小
        }
        
        return cell
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        delegate?.didTapButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let buttonTitles = dataSource?.buttonTitles else {
            return CGSize(width: 0, height: 0)
        }
        
        let title = buttonTitles[indexPath.item]
        let width = title.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) // 根據需要調整字體大小
        ]).width + 20 // 添加一些填充
        
        let height: CGFloat = 20
        let verticalSpacing: CGFloat = 20
        
        return CGSize(width: width, height: height + verticalSpacing)
    }
}


class ButtonCollectionViewButtonCell: UICollectionViewCell {
    static let identifier = "ButtonCollectionViewButtonCell"
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(button)
        button.frame = contentView.bounds
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 設置按鈕的圓角
        button.layer.cornerRadius = 15
        button.clipsToBounds = true // 確保圓角生效
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
