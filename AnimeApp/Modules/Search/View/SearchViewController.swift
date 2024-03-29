//
//  SearchViewController.swift
//  AnimeApp
//
//  Created by Марат on 15.10.2023.
//

import UIKit
import SnapKit

// MARK: - SearchViewController
final class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol!
    
    private lazy var tableView: AnimesTableView = {
        let table = AnimesTableView(.search)
        table.dataSource = self
        table.delegate = self
        table.searchDelegate = self
        
        table.infiniteScroll = { [weak self] _ in
            self?.presenter.loadMore()
        }
        
        return table
    }()
    
    private let blankView: BlankView = {
        let view = BlankView(type: .noSearchResult)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        
        setupViews()
        setupConstraints()
        
        // FIXME: - MOCK calling
        presenter.searchAnimes(with: "")
        
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
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
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let anime = presenter.animes?[indexPath.row] else { return }
        presenter.didSelected(anime)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
}

extension SearchViewController: AnimesTableViewDelegate {
    func updateSearch(with searchText: String) {
        DispatchQueue.main.asyncDeduped(target: self, after: 1.0) { [weak self] in
            self?.presenter.searchAnimes(with: searchText)
        }
    }
}

extension SearchViewController: SearchViewProtocol {
    func updateAnimes(shouldShowBlankView: Bool) {
        let isSearchResultEmpty = presenter.animes?.isEmpty ?? true
        
        tableView.tableViewIsHidden = isSearchResultEmpty
        blankView.isHidden = !(isSearchResultEmpty && shouldShowBlankView)
        tableView.reloadData()
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
    
    func hideActivityIndicator() {
        tableView.finishInfiniteScroll()
    }
}
