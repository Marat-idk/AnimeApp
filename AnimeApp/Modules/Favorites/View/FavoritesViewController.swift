//
//  FavoritesViewController.swift
//  AnimeApp
//
//  Created by Марат on 10.11.2023.
//

import UIKit
import SnapKit

// MARK: - FavoritesViewController
final class FavoritesViewController: UIViewController {
    
    var presenter: FavoritesPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .brandDarkBlue
        table.isOpaque = true
        table.separatorStyle = .none
        table.register(AnimeTableViewCell.self,
                       forCellReuseIdentifier: AnimeTableViewCell.identifier)
        
        table.dataSource = self
        table.delegate = self
        
        return table
    }()
    
    private let blankView: BlankView = {
        let view = BlankView(type: .noFavorites)
        return view
    }()

    // MARK: Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        presenter.fetchAnimes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // FIXME: - MOCK, remove it
        presenter.fetchAnimes()
    }
    
    // MARK: Private methods
    private func setupViews() {
        view.addSubviews(tableView, blankView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        blankView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(190)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Favorites"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandDarkBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16) ?? .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.animes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimeTableViewCell.identifier,
                                                       for: indexPath) as? AnimeTableViewCell else {
            return UITableViewCell()
        }
        let anime = presenter.animes[safe: indexPath.row]
        cell.anime = anime
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let anime = presenter.animes[safe: indexPath.row] else { return }
        presenter.didSelected(anime)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
}

// MARK: - FavoritesViewProtocol
extension FavoritesViewController: FavoritesViewProtocol {
    func updateAnimes() {
        let isFavoritesEmpty = presenter.animes.isEmpty
        
        blankView.isHidden = !isFavoritesEmpty
        
        tableView.reloadData()
    }
}
