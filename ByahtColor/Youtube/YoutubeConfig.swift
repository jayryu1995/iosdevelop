//
//  YoutubeConfig.swift
//  ByahtColor
//
//  Created by jaem on 8/27/24.
//

import Foundation
//import GoogleSignIn
class YoutubeConfig {
    static let shared = YoutubeConfig()

    private init() {}

    func fetchYouTubeChannels(accessToken: String, completion: @escaping (Result<[YouTubeChannel], Error>) -> Void) {
        let url = URL(string: "https://www.googleapis.com/youtube/v3/channels?part=snippet,contentDetails,statistics&mine=true")!
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from YouTube API"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(YouTubeChannelListResponse.self, from: data)
                completion(.success(response.items))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

// MARK: - Data Models

struct YouTubeChannelListResponse: Codable {
    let items: [YouTubeChannel]
}

struct YouTubeChannel: Codable {
    let id: String
    let snippet: Snippet
    let statistics: Statistics
}

struct Snippet: Codable {
    let title: String
    let description: String
}

struct Thumbnail: Codable {
    let url: String
}

struct Statistics: Codable {
    let viewCount: String
    let subscriberCount: String
    let videoCount: String
}
