//
//  AnimeDetailPresenter.swift
//  AnimeApp
//
//  Created by Марат on 27.08.2023.
//

import Foundation

// MARK: - AnimeDetailViewProtocol
protocol AnimeDetailViewProtocol: AnyObject {
    func updateCharacters()
}

// MARK: - AnimeDetailPresenterProtocol
protocol AnimeDetailPresenterProtocol: AnyObject {
    init(view: AnimeDetailViewProtocol, anime: Anime, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol)
    
    var anime: Anime { get }
    var characters: Characters? { get }
    var isFavorite: Bool { get }
    
    func fetchAnimeCharacters()
    func favoriteToggle()
}

// MARK: - AnimeDetailPresenter
final class AnimeDetailPresenter: AnimeDetailPresenterProtocol {
    weak var view: AnimeDetailViewProtocol?
    
    var anime: Anime
    var characters: Characters? {
        didSet {
            view?.updateCharacters()
        }
    }
    
    var isFavorite: Bool {
        return favoritesService.exists(anime)
    }
    
    private let favoritesService: FavoritesServiceProtocol
    private let animeService: AnimeServiceProtocol
    
    init(view: AnimeDetailViewProtocol, anime: Anime, animeService: AnimeServiceProtocol, favoritesService: FavoritesServiceProtocol) {
        self.view = view
        self.anime = anime
        self.animeService = animeService
        self.favoritesService = favoritesService
    }
    
    func fetchAnimeCharacters() {
        animeService.loadCharacters(from: anime.malID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let characters):
                    self?.characters = characters
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func favoriteToggle() {
        isFavorite ? favoritesService.remove(anime) : favoritesService.append(anime)
    }
}
