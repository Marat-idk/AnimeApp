//
//  AnimeDetailPresenter.swift
//  AnimeApp
//
//  Created by Марат on 27.08.2023.
//

import Foundation
import ObjectMapper

// MARK: - AnimeDetailViewProtocol
protocol AnimeDetailViewProtocol: AnyObject {
    func updateCharacters()
}

// MARK: - AnimeDetailPresenterProtocol
protocol AnimeDetailPresenterProtocol: AnyObject {
    init(view: AnimeDetailViewProtocol, anime: Anime)
    
    var anime: Anime { get }
    var characters: Characters? { get }
    
    func fetchAnimeCharacters()
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
    
    init(view: AnimeDetailViewProtocol, anime: Anime) {
        self.view = view
        self.anime = anime
    }
    
    func fetchAnimeCharacters() {
        AnimeService.shared.loadCharacters(from: anime.malID ?? 0) { [weak self] result in
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
}
