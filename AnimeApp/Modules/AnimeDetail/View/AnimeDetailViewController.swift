//
//  AnimeDetailViewController.swift
//  AnimeApp
//
//  Created by Марат on 27.08.2023.
//

import UIKit
import SnapKit
import Kingfisher

// MARK: - AnimeDetailViewController
final class AnimeDetailViewController: UIViewController {
    var presenter: AnimeDetailPresenterProtocol!
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .montserratSemiBold(size: 16)
        lbl.text = presenter.anime.title
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(200)
        }
        return lbl
    }()
    
    private lazy var animeDetailView: AnimeDetailView = {
        let view = AnimeDetailView(anime: presenter.anime)
        view.delegate = self
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var posterBackgroundView: PosterBackgroundView = {
        let view = PosterBackgroundView(anime: presenter.anime)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        presenter.fetchAnimeCharacters()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.addSubviews(posterBackgroundView,
                         animeDetailView
        )
    }
    
    private func setupConstraints() {
        posterBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        animeDetailView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = titleLabel
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        self.customBackButton(with: #selector(backBattonTapped(_:)))
        self.favoriteRightButton(isFavorite: presenter.isFavorite, with: #selector(favoriteButtonTapped(_:)))
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
    }
    
    // MARK: - targets actions
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
//        completionHandler?(true)
        // FIXME: - mock poping
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        print("favoriteButtonTapped")
        presenter.favoriteToggle()
        updateFavoriteRightButtonAppearance(isFavorite: presenter.isFavorite)
    }
}

// MARK: - AnimeDetailViewProtocol
extension AnimeDetailViewController: AnimeDetailViewProtocol {
    func updateCharacters() {
        animeDetailView.characters = presenter.characters
    }
}

// MARK: - AnimeDetailViewDelegate
extension AnimeDetailViewController: AnimeDetailViewDelegate {
    func playButtonTapped() {
        showAlert(title: "Sorry", message: "Playing not available")
    }
    
    func downloadButtonTapped() {
        showAlert(title: "Sorry", message: "Downloading not available")
    }
    
    func shareButtonTapped() {
        showAlert(title: "Sorry", message: "Sharing not available")
    }
}
