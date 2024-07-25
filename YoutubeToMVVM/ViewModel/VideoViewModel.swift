import Foundation
import UIKit

enum ViewControllerType: String {
    case home
    case subscribe
    case content
    case shorts
    case player
}

class VideoModel: Decodable {
    var title: String
    var thumbnailURL: String
    var channelTitle: String
    var videoID: String
    var viewCount: String?
    var daysSinceUpload: String?
    var accountImageURL: String
    
    init(title: String, thumbnailURL: String, channelTitle: String, videoID: String, viewCount: String?, daysSinceUpload: String?, accountImageURL: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.videoID = videoID
        self.viewCount = viewCount
        self.daysSinceUpload = daysSinceUpload
        self.accountImageURL = accountImageURL
    }
    
    init(title: String, thumbnailURL: String, channelTitle: String, videoID: String, accountImageURL: String) {
        self.title = title
        self.thumbnailURL = thumbnailURL
        self.channelTitle = channelTitle
        self.videoID = videoID
        self.accountImageURL = accountImageURL
    }
}

class VideoViewModel {
    
    var data: Observable<[VideoModel]> = Observable([])
    var dataLoadedCallback: (([VideoModel]) -> Void)?
    
    private var dataTask: URLSessionDataTask?
    weak var viewController: BaseViewController?

    let apiKey = "AIzaSyDUC57C1L1XO0N7Y6Zh0oLgzk8PnrB3jWo"
    
    func cancelSearch() {
        dataTask?.cancel()
    }
    
    deinit {
        cancelSearch()
    }

    func searchYouTube<T: Decodable>(query: String, maxResults: Int, responseType: T.Type, completion: @escaping (T?, [String]?) -> Void) {
        let apiKey = self.apiKey
        let baseURL = "https://www.googleapis.com/youtube/v3/search"
        
        var components = URLComponents(string: baseURL)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "maxResults", value: "\(maxResults)"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("VVM Invalid URL")
            completion(nil, nil)
            return
        }
        
        dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("VVM Error: \(String(describing: error))")
                completion(nil, nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                
                var videoIDs: [String] = []
                if let searchResponse = decodedResponse as? SearchResponse {
                    videoIDs = searchResponse.items.map { $0.id.videoID }
                }
                
                completion(decodedResponse, videoIDs)
            } catch {
                print("VVM JSON decoding error: \(error)")
                completion(nil, nil)
            }
        }
        dataTask?.resume()
    }
    
    func loadShortsCell(withQuery query: String, for viewControllerType: ViewControllerType) {
        var maxResults = 0
        switch viewControllerType {
        case .home:
            maxResults = 4
        case .subscribe:
            maxResults = 18
        case .content:
            maxResults = 16
        case .shorts:
            maxResults = 8
        default:
            maxResults = 0
        }
        
        searchYouTube(query: query, maxResults: maxResults, responseType: SearchResponse.self) { [weak self] (searchResponse, videoIDs) in
            guard let self = self else { return }

            if let searchResponse = searchResponse {
                DispatchQueue.main.async {
                    self.handleSearchResponse(searchResponse, for: viewControllerType)
                }
                print("VVM videoIDs == \(videoIDs)")
            } else {
                print("VVM 無法為查詢 \(query) 檢索到結果")
            }
        }
    }
    
    func loadVideoView(withQuery query: String, for viewControllerType: ViewControllerType) {
        let maxResults = (viewControllerType == .home || viewControllerType == .subscribe || viewControllerType == .player) ? 5 : 0
        
        searchYouTube(query: query, maxResults: maxResults, responseType: SearchResponse.self) { [weak self] (searchResponse, videoIDs) in
            guard let self = self else { return }
            
            if let videoIDs = videoIDs {
                print("VVM loadVideoView Video IDs: \(videoIDs)") // Add this line to print the video IDs
                self.fetchVideoDetails(for: videoIDs, maxResults: maxResults, for: viewControllerType)
            } else {
                print("VVM loadVideoView無法為查詢 \(query) 檢索到結果")
            }
        }
    }
    
    private func fetchVideoDetails(for ids: [String], maxResults: Int, for viewControllerType: ViewControllerType) {
        guard let firstID = ids.first else {
            print("VVM No video IDs found")
            return
        }
        
        getDataForVideoID(firstID) { [weak self] videoModel in
            guard let self = self, let videoModel = videoModel else { return }
            
            DispatchQueue.main.async {
                self.viewController?.videoViewModel.data.value = [videoModel]
                self.viewController?.videoViewModel.dataLoadedCallback?([videoModel])
            }
        }
    }
    
    private func getDataForVideoID(_ videoID: String, completion: @escaping (VideoModel?) -> Void) {
        let apiKey = self.apiKey
        let baseURL = "https://www.googleapis.com/youtube/v3/videos"
        
        var components = URLComponents(string: baseURL)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "part", value: "snippet,statistics"),
            URLQueryItem(name: "id", value: videoID),
            URLQueryItem(name: "key", value: apiKey)
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data from API: \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]],
                   let firstItem = items.first {
                    let id = videoID
                    let snippet = firstItem["snippet"] as? [String: Any] ?? [:]
                    let statistics = firstItem["statistics"] as? [String: Any] ?? [:]
                    
                    let title = snippet["title"] as? String ?? "No Title"
                    let channelTitle = snippet["channelTitle"] as? String ?? "Unknown Channel"
                    let publishedAt = snippet["publishedAt"] as? String ?? "Unknown Date"
                    let viewCount = statistics["viewCount"] as? String ?? "View Count Unknown"
                    let thumbnailURL = ((snippet["thumbnails"] as? [String: Any])?["high"] as? [String: Any])?["url"] as? String ?? ""
                    
                    // Assign the same URL to both thumbnailURL and accountImageURL
                    let accountImageURL = thumbnailURL
                    
                    let videoModel = VideoModel(title: title, thumbnailURL: thumbnailURL, channelTitle: channelTitle, videoID: id, viewCount: viewCount, daysSinceUpload: publishedAt, accountImageURL: accountImageURL)
                    completion(videoModel)
                } else {
                    print("Failed to parse JSON")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

    private func handleSearchResponse(_ response: SearchResponse, for viewControllerType: ViewControllerType) {
        switch viewControllerType {
        case .home:
            handleCollectionViewResult(response, viewControllerType: .home, collectionView: viewController?.shortsFrameCollectionView)
            print("VVM Search .home")
        case .subscribe:
            handleCollectionViewResult(response, viewControllerType: .subscribe, collectionView: viewController?.subscribeHoriCollectionView)
            print("VVM Search .subscribe")
        case .content, .shorts, .player:
            handleContentSearchResult(response)
        }
    }
    
    private func handleCollectionViewResult(_ response: SearchResponse, viewControllerType: ViewControllerType, collectionView: UICollectionView?) {
         guard let collectionView = collectionView else { return }
         collectionView.reloadData()
 
         var videoContents: [VideoModel] = []
 
         for item in response.items {
             let title = item.snippet.title
             let thumbnailURL = item.snippet.thumbnails.high.url
             let channelTitle = item.snippet.channelTitle
             let videoID = item.id.videoID
             let accountImageURL = item.snippet.thumbnails.thumbnailsDefault.url
 
             let videoContent = VideoModel(title: title, thumbnailURL: thumbnailURL, channelTitle: channelTitle, videoID: videoID, accountImageURL: accountImageURL)
             videoContents.append(videoContent)
         }
 
         if let shortsCollectionView = collectionView as? ShortsFrameCollectionView {
             shortsCollectionView.videoContents = videoContents
         } else if let subscribeCollectionView = collectionView as? SubscribeHoriCollectionView {
             subscribeCollectionView.subVideoContents = videoContents
         }
     }
    
    private func handleContentSearchResult(_ response: SearchResponse) {
        var videoModels: [VideoModel] = []
        
        for item in response.items {
            let title = item.snippet.title
            let thumbnailURL = item.snippet.thumbnails.high.url
            let channelTitle = item.snippet.channelTitle
            let videoID = item.id.videoID
            let accountImageURL = item.snippet.thumbnails.high.url
            
            let videoModel = VideoModel(title: title, thumbnailURL: thumbnailURL, channelTitle: channelTitle, videoID: videoID, accountImageURL: accountImageURL)
            videoModels.append(videoModel)
        }
        
        DispatchQueue.main.async {
            self.data.value = videoModels
            self.dataLoadedCallback?(videoModels)
        }
    }
}


class APIService {
    
    func getDataForVideoID(_ videoID: String, completion: @escaping (VideoModel?) -> Void) {
        let apiKey = "AIzaSyDUC57C1L1XO0N7Y6Zh0oLgzk8PnrB3jWo"
        let baseURL = "https://www.googleapis.com/youtube/v3/videos"
        
        var components = URLComponents(string: baseURL)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "part", value: "snippet,statistics"),
            URLQueryItem(name: "id", value: videoID),
            URLQueryItem(name: "key", value: apiKey)
        ]
        components.queryItems = queryItems
        
        guard let url = components.url else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data from API: \(String(describing: error))")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let items = json["items"] as? [[String: Any]],
                   let firstItem = items.first {
                    let id = videoID
                    let snippet = firstItem["snippet"] as? [String: Any] ?? [:]
                    let statistics = firstItem["statistics"] as? [String: Any] ?? [:]
                    
                    let title = snippet["title"] as? String ?? "No Title"
                    let channelTitle = snippet["channelTitle"] as? String ?? "Unknown Channel"
                    let publishedAt = snippet["publishedAt"] as? String ?? "Unknown Date"
                    let viewCount = statistics["viewCount"] as? String ?? "View Count Unknown"
                    let thumbnailURL = ((snippet["thumbnails"] as? [String: Any])?["high"] as? [String: Any])?["url"] as? String ?? ""
                    
                    // Assign the same URL to both thumbnailURL and accountImageURL
                    let accountImageURL = thumbnailURL
                    
                    let videoModel = VideoModel(title: title, thumbnailURL: thumbnailURL, channelTitle: channelTitle, videoID: id, viewCount: viewCount, daysSinceUpload: publishedAt, accountImageURL: accountImageURL)
                    completion(videoModel)
                } else {
                    print("Failed to parse JSON")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error)")
                completion(nil)
            }
        }
        
        task.resume()
    }

}

