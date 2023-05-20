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
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        collection.register(MenuHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: MenuHeaderCollectionReusableView.identifier)
        
        collection.register(MenuCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuCollectionViewCell.identifier)
        collection.register(MenuLogoutCollectionViewCell.self,
                            forCellWithReuseIdentifier: MenuLogoutCollectionViewCell.identifier)
        
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandBlue
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension PersonalMenuViewController: PersonalMenuViewProtocol {
    
}

extension PersonalMenuViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PersonalMenuSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = PersonalMenuSection(rawValue: section) else { return 0 }

        switch section {
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
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier, for: indexPath) as? MenuCollectionViewCell,
//              let section = PersonalMenuSection(rawValue: indexPath.section) else {
//                  return UICollectionViewCell()
//              }
        
        guard let section = PersonalMenuSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectionViewCell.identifier,
                                                      for: indexPath)
        
        print(section.description)
        switch section {
        case .account:
            (cell as? MenuCollectionViewCell)?.setData(AccountOptions.allCases[indexPath.row])
        case .general:
            (cell as? MenuCollectionViewCell)?.setData(GeneralOptions.allCases[indexPath.row])
        case .more:
            (cell as? MenuCollectionViewCell)?.setData(MoreOptions.allCases[indexPath.row])
        case .logout:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuLogoutCollectionViewCell.identifier,
                                                      for: indexPath)
        }

        return cell
    }
}

extension PersonalMenuViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("section = \(indexPath.section), item = \(indexPath.item)")
    }
}

extension PersonalMenuViewController: UICollectionViewDelegateFlowLayout {
    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0...2:
            return CGSize(width: UIScreen.main.bounds.width - 48, height: 50)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 60)
    }
    
//    // section inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0...2:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        default:
            return UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        }
        
    }
}
