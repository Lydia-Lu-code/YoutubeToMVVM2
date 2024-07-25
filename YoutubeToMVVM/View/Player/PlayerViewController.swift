
import UIKit
import WebKit

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonCollectionCellDelegate {
    
    
    let buttonTitles = ["👍|👎", "分享", "Remix", "超級感謝", "下載", "剪輯片段", "儲存", "檢舉", ""]
    
    var videosData: [VideoModel] = []
    
    var selectedVideoID: String?
    var selectedTitle: String?
    var selectedChannelTitle: String?
    let apiService = APIService() // 創建 APIService 的實例
    let baseViewController = BaseViewController(vcType: .home)
    
    var data: Observable<[VideoModel]> = Observable([])  // 明確指定型別並初始化為空陣列
    var dataLoadedCallback: (([VideoModel]) -> Void)?
    var videoFrameView = VideoFrameView()
    var videoViewModel = VideoViewModel()
//    var videoViewModel: VideoViewModel!
    
    
    let playerView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let playerView = WKWebView(frame: .zero, configuration: configuration)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        return playerView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var buttonCollectionViewCell: ButtonCollectionViewCell = {
        let cell = ButtonCollectionViewCell(frame: .zero)
        cell.delegate = self
        // 在這裡設置額外的配置，例如 cell 的位置和大小等
        return cell
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(playerView)
        view.addSubview(tableView)
        view.addSubview(buttonCollectionViewCell)
        
        // 设置TableView的代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册单元格
        tableView.register(PlayerTableViewCell.self, forCellReuseIdentifier: "PlayerTableViewCell")

        fetchDataForVideoID(selectedVideoID!)

        buttonCollectionViewCell.dataSource = self
        
        // 设置 WKWebView 的约束，应用 UIEdgeInsets
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 220),
            
            tableView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 禁用 playerView 的滚动功能
        playerView.scrollView.isScrollEnabled = false
        
    }
    
    func didTapButton() {
        print("PVC Button tapped in ButtonCollectionViewCell")
        // 在這裡處理按鈕點擊的相應邏輯
    }
    
    func loadYouTubeVideo(videoID: String, height: Int) {
        let embedHTML = """
        <!DOCTYPE html>
        <html>
        <body style="margin: 0; padding: 0;">
        <iframe width="100%" height="\(height)" src="https://www.youtube.com/embed/\(videoID)?autoplay=1&controls=1&showinfo=1&modestbranding=1&rel=0&loop=0&fs=0" frameborder="0" allowfullscreen="false"></iframe>
        </body>
        </html>
        """
        playerView.loadHTMLString(embedHTML, baseURL: nil)
    }
    
    func fetchDataForVideoID(_ videoID: String) {
        print("PVC fetchDataForVideoID.videoID == \(videoID)")
        apiService.getDataForVideoID(videoID) { [weak self] videoModel in
            guard let self = self, let videoModel = videoModel else {
                print("PVC fetchDataForVideoID() 未能獲取到有效數據")
                return
            }
            
            DispatchQueue.main.async {
                // 更新 videosData
                self.videosData = [videoModel]
                self.loadYouTubeVideo(videoID: videoID, height: 560)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(videosData.count, 9)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as! PlayerTableViewCell
        
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        switch indexPath.row {
        case 0:
            if let videoModel = videosData.first {
                cell.textLabel?.numberOfLines = 0
                
                let formattedViewCount = videoFrameView.convertViewCount(videoModel.viewCount ?? "")
                let formattedUploadDate = videoFrameView.calculateTimeSinceUpload(from: videoModel.daysSinceUpload ?? "")
                
                let firstLineAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 18)
                ]
                
                let secondLineAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12)
                ]
                
                let firstLine = NSMutableAttributedString(string: "\(videoModel.title)", attributes: firstLineAttributes)
                let secondLine = NSMutableAttributedString(string: "\n觀看次數：\(formattedViewCount)次．\(formattedUploadDate)", attributes: secondLineAttributes)
                
                let combinedText = NSMutableAttributedString()
                combinedText.append(firstLine)
                combinedText.append(secondLine)
                
                cell.textLabel?.attributedText = combinedText
            }
  
            print("PVC Setting up cell for row 0, height: \(cell.bounds.height)")
       
        case 1:
            if let videoModel = videosData.first {
                let channelTitle = videoModel.channelTitle ?? ""
                print("PVC channeTitle == \(videoModel.channelTitle ?? "")")
                
                // 设置文本标签
                let attributedText = NSAttributedString(string: channelTitle, attributes: [
                    .font: UIFont.systemFont(ofSize: 12)
                ])
                cell.textLabel?.attributedText = attributedText
                
                // 添加两个按钮
                let button1 = UIButton(type: .custom)
                button1.setTitle("﻿Bell", for: .normal)
                button1.setTitleColor(.blue, for: .normal)
                button1.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button1.translatesAutoresizingMaskIntoConstraints = false
                
                let button2 = UIButton(type: .custom)
                button2.setTitle("﻿訂閱", for: .normal)
                button2.setTitleColor(.blue, for: .normal)
                button2.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button2.translatesAutoresizingMaskIntoConstraints = false
                
                // 添加按钮到 cell.contentView
                cell.contentView.addSubview(button1)
                cell.contentView.addSubview(button2)
                
                // 设置按钮的约束，使其右对齐
                NSLayoutConstraint.activate([
                    button1.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                    button1.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                    
                    button2.trailingAnchor.constraint(equalTo: button1.leadingAnchor, constant: -8),
                    button2.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
                ])
            }
            print("PVC Setting up cell for row 1, height: \(cell.bounds.height)")

        case 2:
            // 添加 buttonCollectionViewCell
            cell.contentView.addSubview(buttonCollectionViewCell)
            buttonCollectionViewCell.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                buttonCollectionViewCell.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                buttonCollectionViewCell.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                buttonCollectionViewCell.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                buttonCollectionViewCell.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
            ])
            
            print("PVC Setting up cell for row 2, height: \(cell.bounds.height)")
            
        case 3:
                
                // 创建容器视图
                let containerView = UIView(frame: cell.contentView.bounds)
                
                // 添加 Label
                let label = UILabel(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: 20))
                label.text = "留言"
                label.font = UIFont.boldSystemFont(ofSize: 14)
                containerView.addSubview(label)
                
                // 添加 ImageView
                let imageView = UIImageView(frame: CGRect(x: 10, y: 40, width: 40, height: 40))
                imageView.layer.cornerRadius = 20
                imageView.clipsToBounds = true
                imageView.image = UIImage(named: "image2") // 替換成你的圖像名稱
                containerView.addSubview(imageView)
                
                // 添加 TextField
                let commentTextField = UITextField(frame: CGRect(x: 60, y: 40, width: containerView.frame.width - 70, height: 40))
                commentTextField.placeholder = "輸入留言"
                commentTextField.borderStyle = .roundedRect
                containerView.addSubview(commentTextField)
                
                // 将容器视图添加到 cell.contentView
                cell.contentView.addSubview(containerView)
            
            print("PVC Setting up cell for row 1, height: \(cell.bounds.height)")

        case 4...:
            if indexPath.row >= 4 {
                let videoFrameView = VideoFrameView(frame: .zero)
                videoFrameView.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(videoFrameView)

                NSLayoutConstraint.activate([
                    videoFrameView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                    videoFrameView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    videoFrameView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    videoFrameView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                ])

                // 定義查詢條件和最大結果數
                let query = "BOYNEXTDOOR" // 替換成你的查詢條件
                let maxResults = 5 // 取五筆資料

                // 使用 searchYouTube 方法搜索相關視頻
                videoViewModel.searchYouTube(query: query, maxResults: maxResults, responseType: SearchResponse.self) { [weak self] (searchResponse: SearchResponse?, videoIDs: [String]?) in
                    guard let self = self, let videoIDs = videoIDs else { return }
                    print("PVC videoIDs == \(videoIDs)")

                    // 確保 videoIDs 的索引不會超出範圍
                    if indexPath.row - 4 < videoIDs.count {
                        let videoID = videoIDs[indexPath.row - 4]
                        self.apiService.getDataForVideoID(videoID) { [weak self] videoModel in
                            guard let self = self, let videoModel = videoModel else { return }
                            DispatchQueue.main.async {
                                videoFrameView.configure(with: videoModel)
                            }
                        }
                    }
                }
            }

        default:
            print("PVC Setting up default cell")
        }
        return cell
    }
    
 
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("PVC Selected row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 2: return UITableView.automaticDimension
        case 3: return 90.0
        default: return 300 // 使用自動行高
        }
    }
    
}

