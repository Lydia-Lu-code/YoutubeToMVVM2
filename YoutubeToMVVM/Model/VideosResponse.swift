//import Foundation
//import UIKit
//
//// MARK: - Welcome
//struct VideosResponse: Codable {
//    let kind, etag: String
//    let items: [VideosItem]
//    let nextPageToken: String?
//    let pageInfo: VideosPageInfo
//}
//
//// MARK: - Item
//struct VideosItem: Codable {
//    let kind, etag, id: String
//    let snippet: VideosSnippet
//    let contentDetails: VideosDetails?
//    let statistics: Statistics?
//}
//
//// MARK: - ContentDetails
//struct VideosDetails: Codable {
//    let duration, dimension, definition, caption: String
//    let licensedContent: Bool
//    let contentRating: VideosRating
//    let projection: String
//    let regionRestriction: RegionRestriction?
//}
//
//// MARK: - ContentRating
//struct VideosRating: Codable {
//}
//
//// MARK: - RegionRestriction
//struct RegionRestriction: Codable {
//    let allowed: [String]?
//    let blocked: [String]?
//}
//
//
//// MARK: - Snippet
//struct VideosSnippet: Codable {
////    let publishedAt: Date
//    let publishedAt: String
//    let channelID, title: String
//    let description: String?
//    let thumbnails: VideosThumbnails
//    let channelTitle: String
//    let tags: [String]?
//    let categoryID, liveBroadcastContent: String
//    let defaultLanguage: String?
//    let localized: Localized
//    let defaultAudioLanguage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case publishedAt
//        case channelID = "channelId"
//        case title, description, thumbnails, channelTitle, tags
//        case categoryID = "categoryId"
//        case liveBroadcastContent, defaultLanguage, localized, defaultAudioLanguage
//    }
//}
//
//
//// MARK: - Localized
//struct Localized: Codable {
//    let title, description: String
//}
//
//// MARK: - Thumbnails
//struct VideosThumbnails: Codable {
//    let thumbnailsDefault, medium, high: VideosDefault
//    let standard: VideosDefault?
//    let maxres: VideosDefault?
//
//    enum CodingKeys: String, CodingKey {
//        case thumbnailsDefault = "default"
//        case medium, high, standard, maxres
//    }
//}
//
//// MARK: - Default
//struct VideosDefault: Codable {
//    let url: String
//    let width, height: Int
//}
//
//// MARK: - Statistics
//struct Statistics: Codable {
//    let viewCount, likeCount, favoriteCount, commentCount: String?
//}
//
//// MARK: - PageInfo
//struct VideosPageInfo: Codable {
//    let totalResults, resultsPerPage: Int
//}
