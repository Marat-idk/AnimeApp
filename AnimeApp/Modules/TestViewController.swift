//
//  TestViewController.swift
//  AnimeApp
//
//  Created by Marat on 07.05.2023.
//

import UIKit

class TestViewController: UIViewController {
    
    private let cell = TestCollectionViewCell()
    
    private let data: [String] = {
        var data: [String] = []
        for _ in 0...30 {
            let count = Int((6...160).randomElement()!)
            data.append(String(repeating: "aboba ", count: count))
        }
        return data
    }()
    
    private let layout = TestCollectionViewFlowLayout(display: .inline)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: TestCollectionViewCell.identifier)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        collection.contentInset = UIEdgeInsets(top: 30, left: 15, bottom: 6, right: 15)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
//        AnimeService.shared.loadAllGenres {
//            let genres = AnimeService.shared.genres
//            genres.forEach {
//                print($0.name)
//            }
//        }
    }

}

extension TestViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.identifier, for: indexPath) as? TestCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = data[indexPath.row]
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath)
            cell.backgroundColor = indexPath.section == 1 ? .red : .cyan
            return cell
        }
    }
}

extension TestViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            layout.display = .inline
//        case 1:
//            layout.display = .list
//        case 2:
//            layout.display = .grid
//        default:
//            break
//        }
//    }
}

extension TestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCollectionViewCell.identifier, for: indexPath) as? TestCollectionViewCell else {
//            return CGSize(width: 10, height: 50)
//        }
//        cell.viewModel = data[indexPath.row]
//
//        // Calculate the desired width for the cell (e.g., the collection view's width)
//        let width = UIScreen.main.bounds.width - 30
//
//        // Invoke the cell's preferredLayoutAttributesFitting method to get the dynamic size
//        let size = cell.preferredLayoutAttributesFitting(UICollectionViewLayoutAttributes(forCellWith: indexPath)).size
//
//        // Return the calculated size for the cell
//
//        return CGSize(width: width, height: size.height)
//        return CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
        
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 50)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 10)
        case 2:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 500)
        default:
            return .zero
        }
        
    }
}
