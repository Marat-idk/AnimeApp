//
//  AnimesPresenter.swift
//  AnimeApp
//
//  Created by Марат on 27.09.2023.
//

import Foundation

// MARK: - AnimesViewProtocol
protocol AnimesViewProtocol: AnyObject {
    func display(newAnimes: Int)
    func hideActivityIndicator()
}

// MARK: - AnimesPresenterProtocol
protocol AnimesPresenterProtocol: AnyObject {
    init(view: AnimesViewProtocol, animeService: AnimeServiceProtocol, searchOptions: AnimeSearchOptions, navigationDelegate: AnimesNavigationDelegate)
    
    var animes: [Anime]? { get set }
    
    func fetchAnimes()
    func didSelect(_ anime: Anime)
}

// MARK: - AnimesNavigationDelegate
protocol AnimesNavigationDelegate: AnyObject {
    func onSelectedAnime(_ anime: Anime)
}

// MARK: - AnimesPresenter
final class AnimesPresenter: AnimesPresenterProtocol {
    weak var view: AnimesViewProtocol?
    weak var navigationDelegate: AnimesNavigationDelegate?
    
    var animes: [Anime]? = []
    
    private let animeService: AnimeServiceProtocol
    private var searchOptions: AnimeSearchOptions
    private var totalPages   = 0
    private var currentPage  = 1
    private let itemsPerPage = 25
    
    init(view: AnimesViewProtocol,
         animeService: AnimeServiceProtocol,
         searchOptions: AnimeSearchOptions,
         navigationDelegate: AnimesNavigationDelegate) {
        
        self.view = view
        self.animeService = animeService
        self.searchOptions = searchOptions
        self.navigationDelegate = navigationDelegate
    }
    
    func fetchAnimes() {
        guard currentPage <= totalPages || totalPages == 0 else {
            view?.hideActivityIndicator()
            return
        }
        searchOptions.pagination?.items?.perPage = itemsPerPage
        searchOptions.pagination?.currentPage = currentPage
        animeService.loadAnime(with: searchOptions) { [weak self] result in
            self?.currentPage += 1
            switch result {
            case .success(let animes):
                DispatchQueue.main.async {
                    if let totalPages = animes.pagination?.lastVisiblePage {
                        self?.totalPages = totalPages
                    }
                    
                    if let animes = animes.data {
                        self?.animes?.append(contentsOf: animes)
                        self?.view?.display(newAnimes: animes.count)
                    }
                }
            case .failure(let error):
                print("anime error = \(error.localizedDescription)")
            }
        }
    }
    
    func didSelect(_ anime: Anime) {
        navigationDelegate?.onSelectedAnime(anime)
    }
}
