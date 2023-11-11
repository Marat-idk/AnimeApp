//
//  FavoritesPresenter.swift
//  AnimeApp
//
//  Created by Марат on 11.11.2023.
//

import Foundation

// MARK: - FavoritesViewProtocol
protocol FavoritesViewProtocol: AnyObject {
    func updateAnimes()
}

// MARK: - FavoritesPresenterProtocol
protocol FavoritesPresenterProtocol: AnyObject {
    init(view: FavoritesViewProtocol, favoritesService: FavoritesServiceProtocol, navigationDelegate: FavoritesNavigationDelegate)
    
    var animes: [Anime] { get }
    
    func fetchAnimes()
    func didSelected(_ anime: Anime)
}

// MARK: - FavoritesNavigationDelegate
protocol FavoritesNavigationDelegate: AnyObject {
    func onSelectedAnime(_ anime: Anime)
}

// MARK: - FavoritesPresenter
final class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    weak var navigationDelegate: FavoritesNavigationDelegate?
    
    var animes: [Anime] = [] {
        didSet {
            view?.updateAnimes()
        }
    }
    
    private var favoritesService: FavoritesServiceProtocol
    
    init(view: FavoritesViewProtocol, favoritesService: FavoritesServiceProtocol, navigationDelegate: FavoritesNavigationDelegate) {
        
        self.view = view
        self.favoritesService = favoritesService
        self.navigationDelegate = navigationDelegate
    }
    
    func fetchAnimes() {
        animes = favoritesService.favoriteAnimes
    }
    
    func didSelected(_ anime: Anime) {
        navigationDelegate?.onSelectedAnime(anime)
    }
}
