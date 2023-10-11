//
//  AnimesPresenter.swift
//  AnimeApp
//
//  Created by Марат on 27.09.2023.
//

import Foundation

// MARK: - AnimesViewProtocol
protocol AnimesViewProtocol: AnyObject {
    func updateAnimes()
    func display(newAnimes: Int)
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
    private let searchOptions: AnimeSearchOptions
    private var totalPages   = 0
    private var currentPage  = 1
    private let itemsPerPage = 25
    
    init(view: AnimesViewProtocol, animeService: AnimeServiceProtocol, searchOptions: AnimeSearchOptions) {
        self.view = view
        self.animeService = animeService
        self.searchOptions = searchOptions
    }
    
    func fetchAnimes() {
//        var searchOptions = AnimeSearchOptions()
//        if let genreId = genre.malID {
//            searchOptions.filter?.genres = [genreId]
//        }
//
//        searchOptions.pagination?.currentPage = currentPage
//
//        // FIXME: - MOCK model
//        searchOptions.filter?.status = .complete
////        model.filter?.rating = .r17
//        searchOptions.pagination?.items?.perPage = itemsPerPage
//        searchOptions.filter?.orderBy = .score
//        searchOptions.filter?.sortOrder = .desc
        
        currentPage += 1
        animeService.loadAnime(with: searchOptions) { [weak self] result in
            switch result {
            case .success(let animes):
                DispatchQueue.main.async {
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
