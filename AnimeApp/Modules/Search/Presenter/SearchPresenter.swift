//
//  SearchPresenter.swift
//  AnimeApp
//
//  Created by Марат on 15.10.2023.
//

import Foundation

// MARK: - SearchViewProtocol
protocol SearchViewProtocol: AnyObject {
    func updateAnimes(shouldShowBlankView: Bool)
    func display(newAnimes: Int)
    func hideActivityIndicator()
}

// MARK: - SearchPresenterProtocol
protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol, animeService: AnimeServiceProtocol)
    
    var animes: [Anime]? { get }
    
    func searchAnimes(with query: String)
    func loadMore()
}

// MARK: - SearchPresenter
final class SearchPresenter: SearchPresenterProtocol {
    weak var view: SearchViewProtocol?
    
    var animes: [Anime]? = []
    
    private let animeService: AnimeServiceProtocol
    private var searchOptions: AnimeSearchOptions?
    private var totalPages   = 0
    private var currentPage  = 1
    private let itemsPerPage = 25
    
    init(view: SearchViewProtocol, animeService: AnimeServiceProtocol) {
        self.view = view
        self.animeService = animeService
    }
    
    func searchAnimes(with query: String) {
        animes?.removeAll()
        view?.updateAnimes(shouldShowBlankView: false)
        currentPage = 1
        
        searchOptions = AnimeSearchOptions()
        searchOptions?.filter?.orderBy = .members
        searchOptions?.filter?.sortOrder = .desc
        searchOptions?.pagination?.currentPage = currentPage
        searchOptions?.pagination?.items?.perPage = itemsPerPage
        searchOptions?.filter?.query = query
        
        animeService.loadAnime(with: searchOptions) { [weak self] result in
            switch result {
            case .success(let animes):
                DispatchQueue.main.async {
                    if let animes = animes.data {
                        self?.animes?.append(contentsOf: animes)
                        self?.view?.updateAnimes(shouldShowBlankView: true)
                    }
                    
                    if let totalPages = animes.pagination?.lastVisiblePage {
                        self?.totalPages = totalPages
                    }
                }
            case .failure(let error):
                print("anime error = \(error.localizedDescription)")
            }
        }
    }
    
    func loadMore() {
        guard currentPage < totalPages else {
            view?.hideActivityIndicator()
            return
        }
        currentPage += 1
        searchOptions?.pagination?.items?.perPage = itemsPerPage
        searchOptions?.pagination?.currentPage = currentPage
        
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
