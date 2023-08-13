//
//  AnimeService.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation
import ObjectMapper

// MARK: - AnimeServiceProtocol
protocol AnimeServiceProtocol {
    var genres: [Genre] { get }
    var topGenres: [Genre] { get }
    func loadAllGenres(completion: @escaping () -> Void)
}

// MARK: - AnimeService
class AnimeService: AnimeServiceProtocol {
    var genres: [Genre] = []
    var topGenres: [Genre] {
        Genre.topGenres()
    }
    
    static let shared = AnimeService()
    
    private var networkManager: NetworkManager
    
    private init(networkManager: NetworkManager = NetworkManagerImpl()) {
        self.networkManager = networkManager
    }
    
    func loadAllGenres(completion: @escaping () -> Void) {
        networkManager.request(with: AnimeRequest.getMangaGenres()) { data, response, error in
            guard error == nil else {
                completion()
                return
            }
            
            guard let data = data else {
                completion()
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                let genres = Mapper<Genre>().mapArray(JSONObject: jsonData?["data"])
                self.genres = genres ?? []
                completion()
            } catch {
                completion()
            }
        }
    }
}
