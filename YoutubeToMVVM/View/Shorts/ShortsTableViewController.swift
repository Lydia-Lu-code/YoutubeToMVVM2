import Foundation
import UIKit
import WebKit

class ShortsTableViewController: UITableViewController {
    
    var videoViewModel: VideoViewModel?
    var videoContents: [VideoModel] = []
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .systemBackground
        
        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: "ShortsTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        tableView.decelerationRate = .fast
        tableView.rowHeight = UIScreen.main.bounds.height
        tableView.delegate = self
        
        navigationItem.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // 初始化 videoViewModel
        videoViewModel = VideoViewModel()
        
        // 設置數據加載回調
        videoViewModel?.dataLoadedCallback = { [weak self] videoModels in
            self?.videoContents = videoModels
            self?.tableView.reloadData()
            
            // 確保在數據加載後進行初始對齊
            self?.snapToNextCell()
            self?.tableView.rowHeight = UIScreen.main.bounds.height
//            self?.alignCellToBottom()
        }
        
        // 加載 shorts cell 的數據
        videoViewModel?.loadShortsCell(withQuery: "IVE, NewJeans, shorts", for: .shorts)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // 假設只有一個分區
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoContents.count // 返回 videoContents 的數量
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShortsTableViewCell", for: indexPath) as! ShortsTableViewCell
        
        let video = videoContents[indexPath.row]
        
        DispatchQueue.main.async {
            var thumbnailImage = UIImage()
            
            // 確認 thumbnailURL 不為 nil，並從 URL 創建 UIImage
            if let thumbnailURL = URL(string: video.thumbnailURL),
               let thumbnailData = try? Data(contentsOf: thumbnailURL) {
                thumbnailImage = UIImage(data: thumbnailData) ?? UIImage()
            }
            
            let backgroundImageView = UIImageView(image: thumbnailImage)
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
            
            cell.backgroundView = backgroundImageView
            
            cell.shortsBtnView.accountButton.setTitle(video.channelTitle, for: .normal)
            cell.shortsBtnView.txtLabel.text = video.title
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellHeight = tableView.rowHeight
        let targetY = targetContentOffset.pointee.y
        
        // 输出调试信息
        print("Velocity: \(velocity)")
        print("Target Y: \(targetY)")
        
        // 判斷滑動方向
        let direction = velocity.y > 0 ? 1 : (velocity.y < 0 ? -1 : 0)
        
        // 如果滑動速度大於 0，表示向上滑動；小於 0，表示向下滑動
        if direction > 0 {
            // 向上滑動過半時，回到上一個 cell
            let index = Int(floor(targetY / cellHeight))
            print("Going up to index \(index)")
            targetContentOffset.pointee = CGPoint(x: 0, y: index * Int(cellHeight))
        } else if direction < 0 {
            // 向下滑動過半時，回到下一個 cell
            let index = Int(ceil(targetY / cellHeight))
            print("Going down to index \(index)")
            targetContentOffset.pointee = CGPoint(x: 0, y: index * Int(cellHeight))
        } else {
            // 沒有速度，直接對齊 cell
            let index = Int(round(targetY / cellHeight))
            print("Snapping to index \(index)")
            targetContentOffset.pointee = CGPoint(x: 0, y: index * Int(cellHeight))
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            snapToNextCell()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToNextCell()
    }
    
    private func snapToNextCell() {
        guard let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows else { return }
        guard let lastVisibleIndexPath = indexPathsForVisibleRows.last else { return }

        let cellHeight = UIScreen.main.bounds.height
        let targetOffsetY = CGFloat(lastVisibleIndexPath.row + 1) * cellHeight

        let maxOffsetY = tableView.contentSize.height - tableView.bounds.height
        tableView.setContentOffset(CGPoint(x: 0, y: min(targetOffsetY, maxOffsetY)), animated: true)
    }


}

