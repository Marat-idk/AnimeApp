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
final class AnimesViewController: UIViewController {
    var presenter: AnimesPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .brandDarkBlue
        table.isOpaque = true
        table.separatorStyle = .none
//        table.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
//        table.layoutMargins = .init(top: 0.0, left: 44, bottom: 0.0, right: 44)
        table.register(AnimeTableViewCell.self,
                       forCellReuseIdentifier: AnimeTableViewCell.identifier)
        
        table.dataSource = self
        table.delegate = self
        
//        table.showsVerticalScrollIndicator = false
        
        table.addInfiniteScroll { [weak self] table in
            self?.presenter.fetchAnimes()
        }
        
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
//        completionHandler?(true)
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
        // FIXME: - mock
        guard let anime = presenter.animes?[indexPath.row] else { return }
        let view = ModuleFactory().createAnimeDetailModule(with: anime)
        navigationController?.pushViewController(view, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard tableView.contentSize.height != .zero else { return }
//        print("±±±±±± scrollView.contentOffset = \(scrollView.contentOffset)")
//        print("±±±±±± tableView.contentSize.height = \(tableView.contentSize.height)")
//        print("±±±±±± scrollView.frame.height = \(scrollView.frame.height)")
//        print("±±±±±± \(tableView.contentSize.height - scrollView.frame.height - 100)")
//
//        let position = scrollView.contentOffset.y
//        if position > tableView.contentSize.height - scrollView.frame.height + 100 {
//            presenter.fetchAnimes()
//            tableView.isScrollEnabled = false
//        }
//    }
}

// MARK: - AnimesViewProtocol
extension AnimesViewController: AnimesViewProtocol {
    
    // FIXME: - переработать методы
    func updateAnimes() {
//        tableView.isScrollEnabled = true
        tableView.reloadData()
        tableView.finishInfiniteScroll()
    }
    
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

}
