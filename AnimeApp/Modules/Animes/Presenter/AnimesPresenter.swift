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
    init(view: AnimesViewProtocol, animeService: AnimeServiceProtocol, searchOptions: AnimeSearchOptions)
    
    var animes: [Anime]? { get set }
    
    func fetchAnimes()
}

// MARK: - AnimesPresenter
final class AnimesPresenter: AnimesPresenterProtocol {
    weak var view: AnimesViewProtocol?
    
    var animes: [Anime]? = []
    
    private let animeService: AnimeServiceProtocol
    private var searchOptions: AnimeSearchOptions
    private var totalPages   = 0
    private var currentPage  = 1
    private let itemsPerPage = 25
    
    init(view: AnimesViewProtocol, animeService: AnimeServiceProtocol, searchOptions: AnimeSearchOptions) {
        self.view = view
        self.animeService = animeService
        self.searchOptions = searchOptions
    }
    
    func fetchAnimes() {
        searchOptions.filter?.genres = [65]
        guard currentPage <= totalPages || totalPages == 0 else {
            view?.hideActivityIndicator()
            return
        }
        currentPage += 1
        animeService.loadAnime(with: searchOptions) { [weak self] result in
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
}
