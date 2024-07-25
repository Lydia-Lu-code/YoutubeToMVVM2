import UIKit

class ContentTableViewCell: UITableViewCell {
    
    var section: Int = 0 // 保存 section 值的屬性
    var conVideoFrameViews: [ConVideoFrameView] = []
    var viewCount: Int = 16
    private var scrollView: UIScrollView!
    private var stackView: UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        createConVideoFrameViews(count: viewCount)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        createConVideoFrameViews(count: viewCount)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 重置視圖的狀態，取消異步任務等
    }
    
    private func calculateStackViewWidth() -> CGFloat {
        let totalConVideoFrameViewWidth = 130 * viewCount
        let totalSpacingWidth = 5 * (viewCount - 1)
        let totalPaddingWidth = 10 * 2
        let stackViewWidth = totalConVideoFrameViewWidth + totalSpacingWidth + totalPaddingWidth
        return CGFloat(stackViewWidth)
    }
    
    private func setupViews() {
        // 初始化 UIScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        
        // 初始化 UIStackView
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        scrollView.addSubview(stackView)
        
        // 设置 UIScrollView 的约束
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // 设置 UIStackView 的约束
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(equalToConstant: calculateStackViewWidth())
        ])
    }

    func configure(with viewModels: [VideoModel]) {
        for (index, viewModel) in viewModels.enumerated() {
            guard index < conVideoFrameViews.count else { break }
            let conVideoFrameView = conVideoFrameViews[index]
            conVideoFrameView.titleLbl.text = viewModel.title
            conVideoFrameView.channelId.text = viewModel.channelTitle
            setImage(from: viewModel.thumbnailURL, to: conVideoFrameView.conVideoImgView)
        }
    }

    func createConVideoFrameViews(count: Int) {
        for _ in 0..<count {
            let conVideoFrameView = ConVideoFrameView()
            conVideoFrameView.widthAnchor.constraint(equalToConstant: 130).isActive = true
            conVideoFrameView.heightAnchor.constraint(equalToConstant: 160).isActive = true
            conVideoFrameViews.append(conVideoFrameView)
            stackView.addArrangedSubview(conVideoFrameView)
        }
    }
    
    private func setImage(from urlString: String, to imageView: UIImageView) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
}
