//
//  AnimesViewController.swift
//  AnimeApp
//
//  Created by Марат on 27.09.2023.
//

import UIKit
import SnapKit
import UIScrollView_InfiniteScroll

// MARK: - AnimesViewController
final class AnimesViewController: UIViewController, FlowCoordinator {
    var presenter: AnimesPresenterProtocol!
    
    var completionHandler: ((Bool) -> Void)?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .brandDarkBlue
        table.isOpaque = true
        table.separatorStyle = .none
        table.register(AnimeTableViewCell.self,
                       forCellReuseIdentifier: AnimeTableViewCell.identifier)
        
        table.dataSource = self
        table.delegate = self
        
        table.addInfiniteScroll { [weak self] _ in
            self?.presenter.fetchAnimes()
        }
        
        let indicator = UIActivityIndicatorView()
        indicator.color = .brandLightBlue
        
        table.infiniteScrollIndicatorView = indicator
        
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        setupNavigationBar()
        
        presenter.fetchAnimes()
    }
    
    // MARK: Private methods
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalTo(view.safeAreaLayoutGuide.snp.verticalEdges)
        }
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandDarkBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        self.customBackButton(with: #selector(backBattonTapped(_:)))
    }
    
    // MARK: targets actions
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
        completionHandler?(true)
        // FIXME: - mock poping
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AnimesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.animes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnimeTableViewCell.identifier,
                                                       for: indexPath) as? AnimeTableViewCell else {
            return UITableViewCell()
        }
        let anime = presenter.animes?[indexPath.row]
        cell.anime = anime
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AnimesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let anime = presenter.animes?[safe: indexPath.row] else { return }
        presenter.didSelect(anime)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
}

// MARK: - AnimesViewProtocol
extension AnimesViewController: AnimesViewProtocol {
    func display(newAnimes: Int) {
        guard let animes = presenter.animes else { return }
        
        let isAdded = animes.count + newAnimes != animes.count
        
        print("isAdded = \(isAdded)")
        
        if isAdded {
            let start = animes.count - newAnimes
            let end = animes.count
            let indexPaths = (start..<end).map { IndexPath(row: $0, section: 0) }
            UIView.performWithoutAnimation {
                tableView.insertRows(at: indexPaths, with: .none)
            }
        } else {
            tableView.reloadData()
        }
        tableView.finishInfiniteScroll()
    }
    
    func hideActivityIndicator() {
        tableView.finishInfiniteScroll()
    }

}
