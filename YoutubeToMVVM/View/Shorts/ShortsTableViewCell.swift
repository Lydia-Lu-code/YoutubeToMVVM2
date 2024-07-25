
import UIKit

class ShortsTableViewCell: UITableViewCell {
    
    let emojiBtnView = ShortsEmojiBtnView()
    let shortsBtnView = ShortsBtnView()

    
//    var videoContent: String? // 新增一個用於存儲視頻內容的屬性
//    var videoContents: [VideoModel] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    
    func setViews() {
        contentView.addSubview(emojiBtnView)
        contentView.addSubview(shortsBtnView)
        
        emojiBtnView.translatesAutoresizingMaskIntoConstraints = false
        shortsBtnView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emojiBtnView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -90)
        ])

        NSLayoutConstraint.activate([
            shortsBtnView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shortsBtnView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -230), // 将顶部对齐到 contentView 的底部
            shortsBtnView.widthAnchor.constraint(equalToConstant: 320) // 固定宽度为 320
        ])
    }
}




