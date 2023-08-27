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
    var topGenresAnime: [Genre: [Anime]] { get }
    func loadAllGenres(completion: @escaping () -> Void)
    func loadAnime(with model: AnimeRequest.Model?, completion: @escaping (Result<Animes, Error>) -> Void)
    func loadTopGenresAnime(completion: @escaping () -> Void)
}

extension AnimeServiceProtocol {
    func loadAnime(completion: @escaping (Result<Animes, Error>) -> Void) {
        loadAnime(with: nil, completion: completion)
    }
}

// MARK: - AnimeService
class AnimeService: AnimeServiceProtocol {
    var genres: [Genre] = []
    var topGenres: [Genre] {
        Genre.topGenres()
    }
    
    var topGenresAnime: [Genre: [Anime]] = [:]
    
    static let shared = AnimeService()
    
    private var networkManager: NetworkManager
    
    private init(networkManager: NetworkManager = NetworkManagerImpl()) {
        self.networkManager = networkManager
    }
    
    func loadAllGenres(completion: @escaping () -> Void) {
        networkManager.request(with: AnimeRequest.mangaGenres()) { data, _, error in
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
    
    func loadAnime(with model: AnimeRequest.Model? = nil, completion: @escaping (Result<Animes, Error>) -> Void) {
        networkManager.request(with: AnimeRequest.animeSearch(model)) { data, _, error in
            guard error == nil else {
                completion(.failure(NetworkError.connectionFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataAvailable))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                
                if let animes = Mapper<Animes>().map(JSONObject: jsonData) {
                    completion(.success(animes))
                } else {
                    completion(.failure(APIError.canNotProcessData))
                }
            } catch {
                completion(.failure(APIError.canNotProcessData))
            }
        }
    }
    
    func loadTopGenresAnime(completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let concurrentQueue = DispatchQueue(label: "conncurentQueue")
        
        for (index, genre) in topGenres.enumerated() {
            group.enter()
            let delay: TimeInterval = 2 * Double(index / 3) + (index / 3 == 0 ? 0 : 2.5)
            
            // FIXME: - log print should be removed
            print("++++++++++++++delay = \(delay)")
            
            concurrentQueue.asyncAfter(deadline: .now() + delay, qos: .userInitiated) {
                print("++++++ entered at index =\(index)")
                self.loadAnimeBy(genre: genre) {
                    print("++++++ leaving at index =\(index)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            let animesByGenre = self.topGenresAnime
            
            // FIXME: - log print should be removed
            print("++++++++ animesByGenre \(animesByGenre.count)")
            
            for (genre, animes) in animesByGenre {
                print("genre = \(genre) and count = \(animes.count)")
            }
            completion()
        }
    }
    
    private func loadAnimeBy(genre: Genre, completion: @escaping () -> Void) {
        var model = AnimeRequest.Model()
        model.filter?.status = .complete
//        model.filter?.rating = .r17
        model.pagination?.items?.perPage = 10
        model.filter?.orderBy = .score
        model.filter?.sortOrder = .desc
        
        if let genreId = genre.malID, genreId > 0 {
            model.filter?.genres = [genreId]
        }
        
        loadAnime(with: model) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let animes):
                    self?.topGenresAnime[genre] = animes.data
                case .failure(let error):
                    print(error.localizedDescription)
                }
                completion()
            }
        }
    }
}
