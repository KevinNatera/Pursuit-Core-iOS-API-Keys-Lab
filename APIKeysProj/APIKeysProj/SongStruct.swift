//
//  SongStruct.swift
//  APIKeysProj
//
//  Created by Kevin Natera on 9/9/19.
//  Copyright © 2019 Kevin Natera. All rights reserved.
//

import Foundation
import UIKit

struct SongWrapper: Codable {
    let message: MessageWrapper
    
    static func getSongs(userInput: String?,completionHandler: @escaping (Result<[SongWrapper],Error>) -> () ) {
        var url = "http://api.musixmatch.com/ws/1.1/track.search?q_artist=a&f_has_lyrics&apikey=\(Secrets.init().apiKey)"
        if let word = userInput {
            let searchString = word.replacingOccurrences(of: " ", with: "-")
            url = "http://api.musixmatch.com/ws/1.1/track.search?q_artist=\(searchString)&f_has_lyrics&apikey=\(Secrets.init().apiKey)"
        }
        
        NetworkManager.shared.getData(urlString: url) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success(let data):
                do {
                    let songs = try JSONDecoder().decode([SongWrapper].self, from: data)
                    completionHandler(.success(songs))
                } catch {
                    completionHandler(.failure(ErrorHandling.decodingError))
                    print(error)
                }
            }
        }
    }
}

struct MessageWrapper: Codable {
    let body: BodyWrapper
}

struct BodyWrapper: Codable {
    let track_list: [TrackListWrapper]
}

struct TrackListWrapper: Codable {
    let track: Track
}

struct Track: Codable {
    let track_id: Int
    let track_name: String
    let artist_name: String
}
