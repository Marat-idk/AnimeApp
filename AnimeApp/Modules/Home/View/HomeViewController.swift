//
//  HomeViewController.swift
//  AnimeApp
//
//  Created by Марат on 22.07.2023.
//

import UIKit
import SnapKit

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.isOpaque = true
        
        // main section
        collection.register(PersonalCollectionViewCell.self,
                            forCellWithReuseIdentifier: PersonalCollectionViewCell.identifier)
        collection.register(SearchCollectionViewCell.self,
                            forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        collection.register(CarouselCollectionViewCell.self,
                            forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        
        // category section
        collection.register(CategoryCollectionViewCell.self,
                            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        // most popular section
        collection.register(MostPopularCollectionViewCell.self,
                            forCellWithReuseIdentifier: MostPopularCollectionViewCell.identifier)
        
        collection.register(HomeHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: HomeHeaderCollectionReusableView.identifier)
        
        collection.bounces = false
        collection.showsVerticalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        hideKeyboardWhenTappedAround()
        
        presenter.fetchAnimeForSelectedGenre()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Private methods
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return HomeSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = HomeSection(rawValue: section) else { return 0 }
        
        switch section {
        case .main:
            return MainCells.allCases.count
        case .categories:
            return CategoriesCells.allCases.count
        case .mostPopular:
            return MostPopularCells.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                               withReuseIdentifier: HomeHeaderCollectionReusableView.identifier,
                                                                               for: indexPath) as? HomeHeaderCollectionReusableView else {
                return UICollectionViewCell()
            }
            let section = HomeSection(rawValue: indexPath.section)
            header.section = section
            header.delegate = presenter
            return header
        default:
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = HomeSection(rawValue: indexPath.section) else { return UICollectionViewCell() }
        
        switch section {
        case .main:
            let cellType = MainCells(rawValue: indexPath.row)
            
            switch cellType {
            case .personal:
                return personalCollectionViewCell(collectionView, for: indexPath)
            case .search:
                return searchCollectionViewCell(collectionView, for: indexPath)
            case .carausel:
                return carouselCollectionViewCell(collectionView, for: indexPath)
            case .none:
                return UICollectionViewCell()
            }
        case .categories:
            return categoryCollectionViewCell(collectionView, for: indexPath)
        case .mostPopular:
            return mostPopularCollectionViewCell(collectionView, for: indexPath)
        }
    }
    
    private func personalCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalCollectionViewCell.identifier,
                                                            for: indexPath) as? PersonalCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    private func searchCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier,
                                                            for: indexPath) as? SearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = presenter
        return cell
    }
    
    private func carouselCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier,
                                                            for: indexPath) as? CarouselCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    private func categoryCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier,
                                                            for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.genres = presenter.topGenres
        cell.delegate = presenter
        return cell
    }
    
    private func mostPopularCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostPopularCollectionViewCell.identifier,
                                                            for: indexPath) as? MostPopularCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.animes = presenter.selectedGenreAnime
        cell.delegate = presenter
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = HomeSection(rawValue: section) else { return .zero }
        
        return CGSize(width: section.width, height: section.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = HomeSection(rawValue: indexPath.section) else { return .zero }
        
        var size: CGSize?
        var cellType: (any HomeCellType)! = MainCells(rawValue: 0)
        
        switch section {
        case .main:
            cellType = MainCells(rawValue: indexPath.row) ?? .none
        case .categories:
            cellType = CategoriesCells(rawValue: indexPath.row) ?? .none
        case .mostPopular:
            cellType = MostPopularCells(rawValue: indexPath.row) ?? .none
        }
        
        size = CGSize(width: cellType.width, height: cellType.height)
        return size ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 33.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 24, right: 0)
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func updateCategories() {
        let section = HomeSection.categories.rawValue
        let item = CategoriesCells.genre.rawValue
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? CategoryCollectionViewCell {
            cell.genres = presenter.topGenres
        }
    }
    
    func updateMostPopular(with animes: [Anime]) {
        let section = HomeSection.mostPopular.rawValue
        let item = MostPopularCells.mostPopular.rawValue
        
        if let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? MostPopularCollectionViewCell {
            cell.animes = animes
        }
    }
}
