//
//  HomePresenter.swift
//  AnimeApp
//
//  Created by Марат on 09.08.2023.
//

import Foundation

// MARK: - CollectionViewCellAndHeaderDelegate
typealias CollectionViewCellAndHeaderDelegate = CategoryCollectionViewCellDelegate & HomeHeaderCollectionReusableViewDelegate & SearchCollectionViewCellDelegate & MostPopularCollectionViewCellDelegate

// MARK: - HomeViewProtocol
protocol HomeViewProtocol: AnyObject {
    func updateCategories()
    func updateMostPopular(with animes: [Anime])
}

// MARK: - HomePresenterProtocol
protocol HomePresenterProtocol: AnyObject, CollectionViewCellAndHeaderDelegate {
    init(view: HomeViewProtocol, userService: UserServiceProtocol, animeService: AnimeServiceProtocol, navigationDelegate: HomeNavigationDelegate?)
    
    var topGenres: [Genre] { get }
    var selectedGenreAnime: [Anime] { get }
    func fetchAnimeForSelectedGenre()
}

protocol HomeNavigationDelegate: AnyObject {
    func onSelectedAnime(_ anime: Anime)
    func onSelectedMostPopularGenre(with searchOptions: AnimeSearchOptions)
}

final class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?
    weak var navigationDelegate: HomeNavigationDelegate?
    
    var topGenres: [Genre] = []
    var currentSelectedGenre: Genre?
    var selectedGenreAnime: [Anime] = [] {
        didSet {
            view?.updateMostPopular(with: selectedGenreAnime)
        }
    }
    
    private var userService: UserServiceProtocol?
    private var animeService: AnimeServiceProtocol?
    
    private var mostPopularAnimes: Animes? {
        didSet {
            guard let data = mostPopularAnimes?.data else { return }
            view?.updateMostPopular(with: data)
        }
    }
    
    init(view: HomeViewProtocol, userService: UserServiceProtocol, animeService: AnimeServiceProtocol, navigationDelegate: HomeNavigationDelegate?) {
        self.view = view
        self.navigationDelegate = navigationDelegate
        self.userService = userService
        self.animeService = animeService
        self.navigationDelegate = navigationDelegate
        
        // FIXME: - remove
        self.topGenres = animeService.topGenres
        self.currentSelectedGenre = topGenres.first(where: { $0.isSelected == true })
    }
    
    func fetchAnimeForSelectedGenre() {
        animeService?.loadTopGenresAnime { [weak self] in
            guard let self = self else { return }
            
            if let defaultSelectedGenre = self.topGenres.first(where: { $0.isSelected == true }) {
                self.selectedGenreAnime = animeService?.topGenresAnime[defaultSelectedGenre] ?? []
            }
        }
    }
    
    // TODO: Will be implemented later
    func searchAnimes(_ searchText: String) {
//        var searchOptions = animeService?.mostPopularAnimesSearchOptions(for: topGenres.first!)
//        searchOptions?.filter?.genres = nil
//        searchOptions?.filter?.query = searchText
//        print("searchText = \(searchText)")
//        animeService?.loadAnime(with: searchOptions, completion: { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let animes):
//                guard let animes = animes.data else { return }
//                animes.forEach { anime in
//                    print("Anime title = \(anime.title)")
//                }
//            case .failure(let error):
//                print("searchAnimes error = \(error.localizedDescription)")
//            }
//        })
    }
    
    func didSelected(_ genre: Genre) {
        currentSelectedGenre = genre
        for index in topGenres.indices {
            topGenres[index].isSelected = topGenres[index] == genre
        }
        view?.updateCategories()
        if let defaultSelectedGenre = self.topGenres.first(where: { $0.isSelected == true }) {
            self.selectedGenreAnime = animeService?.topGenresAnime[defaultSelectedGenre] ?? []
        }
    }
    
    func headerButtonTapped(on section: HomeSection) {
        switch section {
        case .mostPopular:
            guard let genre = currentSelectedGenre,
                  let animeService = animeService else { return }
            let searchOptions = animeService.mostPopularAnimesSearchOptions(for: genre)
            navigationDelegate?.onSelectedMostPopularGenre(with: searchOptions)
        default:
            break
        }
    }
    
    func didSelect(_ anime: Anime) {
        navigationDelegate?.onSelectedAnime(anime)
    }
}
