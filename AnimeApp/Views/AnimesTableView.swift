//
//  AnimesTableView.swift
//  AnimeApp
//
//  Created by Марат on 15.10.2023.
//

import UIKit
import SnapKit

// MARK: - AnimesTableView
final class AnimesTableView: UIView {
    
    private let mode: DisplayMode
    
    private var cancelTrailingConstraint: Constraint?
    private var stackViewTrailingToSuperviewConstraint: Constraint?
    private var stackViewTrailingToCancelButtonConstraint: Constraint?
    
    weak var dataSource: UITableViewDataSource? {
        get {
            tableView.dataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }
    
    weak var delegate: UITableViewDelegate? {
        get {
            tableView.delegate
        }
        set {
            tableView.delegate = newValue
        }
    }
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView(mode: .withCancelButton)
        return searchView
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .brandDarkBlue
        table.isOpaque = true
        table.separatorStyle = .none
        table.register(AnimeTableViewCell.self,
                       forCellReuseIdentifier: AnimeTableViewCell.identifier)
        
        // TODO: - перенеси на уровень выше
//        table.addInfiniteScroll { [weak self] _ in
//            self?.presenter.fetchAnimes()
//        }
//
//        let indicator = UIActivityIndicatorView()
//        indicator.color = .brandLightBlue
//
//        table.infiniteScrollIndicatorView = indicator
        
        return table
    }()
    
    // MARK: Init
    init(frame: CGRect, mode: DisplayMode) {
        self.mode = mode
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(_ mode: DisplayMode) {
        self.init(frame: .zero, mode: mode)
    }
    
    // MARK: Override methods
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Private methods
    private func setupViews() {
        addSubview(tableView)
        if mode == .search {
            addSubview(searchView)
        }
    }
    
    private func setupConstraints() {
        switch mode {
        case .normal:
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        case .search:
            searchView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.equalToSuperview().offset(24)
                $0.trailing.greaterThanOrEqualToSuperview().offset(-24)
                $0.height.equalTo(40)
            }
            
            tableView.snp.makeConstraints {
                $0.top.equalTo(searchView.snp.bottom).offset(24)
                $0.bottom.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    // MARK: Public methods
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - AnimesTableViewType
extension AnimesTableView {
    enum DisplayMode {
        case normal
        case search
    }
}
