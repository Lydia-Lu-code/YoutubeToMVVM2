import UIKit
import Foundation
import WebKit

class VideoFrameView: UIView {
    
    // 定義子視圖
    var videoImgView: UIImageView = {
        let vidView = UIImageView()
        vidView.translatesAutoresizingMaskIntoConstraints = false
        vidView.contentMode = .scaleAspectFill
        vidView.clipsToBounds = true
        return vidView
    }()
    
    lazy var videoView: WKWebView = {
        let vidView = WKWebView()
        vidView.translatesAutoresizingMaskIntoConstraints = false
        vidView.contentMode = .scaleAspectFill
        return vidView
    }()
    
    var photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = .darkGray
        return imgView
    }()
    
    var labelMidTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    var labelMidOther: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    var buttonRight: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        btn.tintColor = .lightGray
        return btn
    }()
    
    // 初始化方法
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setCustomVideoFrameViewLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 設置子視圖佈局
    private func setCustomVideoFrameViewLayout() {
        self.addSubview(videoImgView)
//        self.addSubview(videoView)
        self.addSubview(photoImageView)
        self.addSubview(labelMidTitle)
        self.addSubview(labelMidOther)
        self.addSubview(buttonRight)
        
        // 設置圓形外觀
        photoImageView.layer.cornerRadius = 30
        photoImageView.clipsToBounds = true
        buttonRight.layer.cornerRadius = 30
        buttonRight.clipsToBounds = true
        
        // 設置約束
        NSLayoutConstraint.activate([
            videoImgView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            videoImgView.topAnchor.constraint(equalTo: self.topAnchor),
            videoImgView.widthAnchor.constraint(equalTo: videoImgView.heightAnchor, multiplier: 320/180),
            videoImgView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
//            videoView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            videoView.topAnchor.constraint(equalTo: self.topAnchor),
//            videoView.widthAnchor.constraint(equalTo: videoView.heightAnchor, multiplier: 320/180),
//            videoView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: videoImgView.bottomAnchor, constant: 8),
            photoImageView.heightAnchor.constraint(equalToConstant: 60),
            photoImageView.widthAnchor.constraint(equalToConstant: 60),
            
            buttonRight.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonRight.topAnchor.constraint(equalTo: videoImgView.bottomAnchor, constant: 8),
            buttonRight.heightAnchor.constraint(equalToConstant: 60),
            buttonRight.widthAnchor.constraint(equalToConstant: 60),
            
            labelMidTitle.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            labelMidTitle.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            labelMidTitle.heightAnchor.constraint(equalToConstant: 35),
            labelMidTitle.widthAnchor.constraint(equalTo: videoImgView.widthAnchor, constant: -80),
            
            labelMidOther.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 5),
            labelMidOther.topAnchor.constraint(equalTo: labelMidTitle.bottomAnchor),
            labelMidOther.heightAnchor.constraint(equalToConstant: 25),
            labelMidOther.widthAnchor.constraint(equalTo: videoImgView.widthAnchor, constant: -80)
        ])
    }
    
    func configure(with videoModel: VideoModel) {
        labelMidTitle.text = videoModel.title
        let channelTitle = videoModel.channelTitle
        let viewCountText = convertViewCount(videoModel.viewCount!)
        let timeSinceUploadText = calculateTimeSinceUpload(from: videoModel.daysSinceUpload!)
        labelMidOther.text = "\(channelTitle)．觀看次數： \(viewCountText)次．\(timeSinceUploadText)"
        
        // 加載視頻
        loadVideoPlayer(with: videoModel.videoID, height: 560)
        
        loadImage(from: videoModel.thumbnailURL) { [weak self] image in
            self?.videoImgView.image = image
        }
        loadImage(from: videoModel.accountImageURL) { [weak self] image in
            self?.photoImageView.image = image
        }
        
        
    }

    // 加載視頻播放器
    private func loadVideoPlayer(with videoID: String, height: Int) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <body style="margin: 0px; padding: 0px;">
        <iframe width="100%" height="\(height)" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
        </body>
        </html>
        """
        
        videoView.loadHTMLString(embedHTML, baseURL: nil)
    }
    

    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Failed to load image:", error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }

    
    // 將觀看次數轉換為人性化的格式
    func convertViewCount(_ viewCountString: String) -> String {
        guard let viewCount = Int(viewCountString) else {
            return viewCountString // 如果無法解析為整數，返回原始字串
        }
        
        if viewCount > 29999 {
            return "\(viewCount / 10000)萬"
        } else if viewCount > 19999 {
            return "\(viewCount / 10000).\(viewCount % 10000 / 1000)萬"
        } else if viewCount > 9999 {
            return "\(viewCount / 10000)萬"
        } else {
            return "\(viewCount)"
        }
    }
    
    func calculateTimeSinceUpload(from publishTime: String) -> String {
        // 將 publishTime 轉換為日期對象
        let dateFormatter = ISO8601DateFormatter()
        if let publishDate = dateFormatter.date(from: publishTime) {
            // 計算距今的時間間隔
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: publishDate, to: Date())
            
            // 判斷距離上傳的時間，決定顯示的格式
            if let years = components.year, years > 0 {
                return "\(years)年前"
            } else if let months = components.month, months > 0 {
                return "\(months)個月前"
            } else if let days = components.day, days > 0 {
                return "\(days)天前"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours)個小時前"
            } else {
                return "剛剛"
            }
        }
        return ""
    }
}

