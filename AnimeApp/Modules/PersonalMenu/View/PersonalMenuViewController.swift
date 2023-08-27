//
//  PersonalMenuViewController.swift
//  AnimeApp
//
//  Created by Marat on 14.05.2023.
//

import UIKit
import SnapKit

// MARK: - PersonalMenuViewController
final class PersonalMenuViewController: UIViewController {
    
    var presenter: PersonalMenuPresenterProtocol!
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.contentInset = UIEdgeInsets(top: 24, left: 24, bottom: 16, right: 24)
        collection.register(MenuHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MenuHeaderCollectionReusableView.identifier)
        
        collection.register(MenuProfileCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuProfileCollectionViewCell.identifier)
        collection.register(MenuCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collection.register(MenuLogoutCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuLogoutCollectionViewCell.identifier)
        
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandDarkBlue
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        navigationController?.overrideUserInterfaceStyle = .dark
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

extension PersonalMenuViewController: PersonalMenuViewProtocol {
    
}

// MARK: - UICollectionViewDataSource
extension PersonalMenuViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PersonalMenuSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = PersonalMenuSection(rawValue: section) else { return 0 }

        switch section {
        case .profileEdit:
            return ProfileEditOptions.allCases.count
        case .account:
            return AccountOptions.allCases.count
        case .general:
            return GeneralOptions.allCases.count
        case .more:
            return MoreOptions.allCases.count
        case .logout:
            return LogoutOptions.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuHeaderCollectionReusableView.identifier, for: indexPath) as? MenuHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            let section = PersonalMenuSection(rawValue: indexPath.section)
            headerView.section = section
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let section = PersonalMenuSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier,
                                                      for: indexPath)
        
        print(section.description)
        switch section {
        case .profileEdit:
            return getMenuProfileCollectionViewCell(collectionView, for: indexPath)
        case .account:
            return getMenuCollectionViewCell(collectionView, for: indexPath, AccountOptions.allCases[indexPath.row])
        case .general:
            return getMenuCollectionViewCell(collectionView, for: indexPath, GeneralOptions.allCases[indexPath.row])
        case .more:
            return getMenuCollectionViewCell(collectionView, for: indexPath, MoreOptions.allCases[indexPath.row])
        case .logout:
            return getMenuLogoutCollectionViewCell(collectionView, for: indexPath)
        }

        return cell
    }
    
    private func getMenuProfileCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuProfileCollectionViewCell.identifier, for: indexPath) as? MenuProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        // FIXME: временная моковое говно, обязательно исправь
        cell.userPersonalData = UserService.shared.userPersonal
        return cell
    }
    
    private func getMenuCollectionViewCell<T: PersonalMenuCellType>(_ collectionView: UICollectionView, for indexPath: IndexPath, _ cellType: T) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setData(cellType)
        return cell
    }
    
    private func getMenuLogoutCollectionViewCell(_ collectionView: UICollectionView, for indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuLogoutCollectionViewCell.identifier, for: indexPath) as? MenuLogoutCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PersonalMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = PersonalMenuSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .account, .general, .more:
            presenter.menuItemDidSelect(at: indexPath)
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonalMenuViewController: UICollectionViewDelegateFlowLayout {
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let section = PersonalMenuSection(rawValue: section) else { return .zero }
        
        switch section {
        case .account, .general, .more:
            return CGSize(width: UIScreen.main.bounds.width - 48, height: 50)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 60)
    }
    
    // section inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        guard let section = PersonalMenuSection(rawValue: section) else { return .zero }

        switch section {
        case .profileEdit, .account, .general, .more:
            return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        default:
            return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
    }
}

// MARK: - MenuProfileCollectionViewCellDelegate
extension PersonalMenuViewController: MenuProfileCollectionViewCellDelegate {
    func editProfileButtonTapped() {
        let section = PersonalMenuSection.profileEdit.rawValue
        let item = ProfileEditOptions.profileEdit.rawValue
        presenter.menuItemDidSelect(at: IndexPath(item: item, section: section))
    }
}

// MARK: - MenuLogoutCollectionViewCellDelegate
extension PersonalMenuViewController: MenuLogoutCollectionViewCellDelegate {
    func logoutButtonTapped() {
        let section = PersonalMenuSection.logout.rawValue
        let item = LogoutOptions.logout.rawValue
        presenter.menuItemDidSelect(at: IndexPath(item: item, section: section))
    }
}

// MARK: - UpdatableWithUserPersonal
extension PersonalMenuViewController: UpdatableWithUserPersonal {
    func update(_ userPersonal: UserPersonal) {
        let section = PersonalMenuSection.profileEdit.rawValue
        let item = ProfileEditOptions.profileEdit.rawValue
        guard let cell = collectionView.cellForItem(at: IndexPath(item: item, section: section)) as? MenuProfileCollectionViewCell else {
            return
        }
        cell.userPersonalData = userPersonal
        collectionView.reloadData()
    }
}
