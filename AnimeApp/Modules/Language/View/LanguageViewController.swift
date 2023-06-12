//
//  LanguageViewController.swift
//  AnimeApp
//
//  Created by Марат on 11.06.2023.
//

import UIKit
import SnapKit

// MARK: - LanguageViewController
final class LanguageViewController: UIViewController, FlowCoordinator {
    
    var completionHandler: ((Bool) -> Void)?
    var presenter: LanguagePresenterProtocol!
    
    private var selectedLanguage: any LanguageMenuCellType = SuggestedLanguagesOptions.english
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .brandDarkBlue
        collection.contentInset = UIEdgeInsets(top: 24, left: 24, bottom: 16, right: 24)
        
        collection.register(LanguageHeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: LanguageHeaderCollectionReusableView.identifier)
        
        collection.register(LanguageCollectionViewCell.self, forCellWithReuseIdentifier: LanguageCollectionViewCell.identifier)
        
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
        navigationItem.title = "Language"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandDarkBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.montserratSemiBold(size: 16) ?? .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        self.customBackButton(with: #selector(backBattonTapped(_:)))
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func backBattonTapped(_ sender: UITapGestureRecognizer) {
        print("backBattonTapped")
        completionHandler?(true)
    }
}

// MARK: - LanguageViewProtocol
extension LanguageViewController: LanguageViewProtocol {
    
}

// MARK: - UICollectionViewDataSource
extension LanguageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return LanguageSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = LanguageSection(rawValue: section) else { return 0 }
        
        switch section {
        case .suggestedLanguages:
            return SuggestedLanguagesOptions.allCases.count
        case .otherLanguages:
            return OtherLanguagesOptions.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: LanguageHeaderCollectionReusableView.identifier,
                                                                               for: indexPath) as? LanguageHeaderCollectionReusableView else {
                return UICollectionReusableView()
            }
            let section = LanguageSection(rawValue: indexPath.section)
            headerView.section = section
            return headerView
        default:
            return UICollectionReusableView()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LanguageCollectionViewCell.identifier, for: indexPath) as? LanguageCollectionViewCell,
            let section = LanguageSection(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .suggestedLanguages:
            let language = SuggestedLanguagesOptions.allCases[indexPath.item]
            cell.setData(language)
            
            if let selectedLanguage = selectedLanguage as? SuggestedLanguagesOptions,
               selectedLanguage == language {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
            
        case .otherLanguages:
            let language = OtherLanguagesOptions.allCases[indexPath.item]
            cell.setData(language)
            
            if let selectedLanguage = selectedLanguage as? OtherLanguagesOptions,
               selectedLanguage == language {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
        }
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension LanguageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected section = \(indexPath.section), row = \(indexPath.row)")
        guard let section = LanguageSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .suggestedLanguages:
            selectedLanguage = SuggestedLanguagesOptions.allCases[indexPath.row]
        case .otherLanguages:
            selectedLanguage = OtherLanguagesOptions.allCases[indexPath.row]
        }
        presenter.update(with: selectedLanguage.description)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LanguageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 48, height: 59)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
}
