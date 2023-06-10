//
//  AnimeService.swift
//  AnimeApp
//
//  Created by Marat on 09.05.2023.
//

import Foundation
import ObjectMapper

protocol AnimeServiceProtocol {
    var genres: [Genre] { get }
    func loadAllGenres(completion: @escaping () -> Void)
}

class AnimeService: AnimeServiceProtocol {
    var genres: [Genre] = []
    
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
