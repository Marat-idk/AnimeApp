//
//  LanguagePresenter.swift
//  AnimeApp
//
//  Created by Марат on 12.06.2023.
//

import Foundation

protocol LanguageUpdatingDelegate: AnyObject {
    func update(with language: String)
}

// MARK: - LanguageViewProtocol
protocol LanguageViewProtocol: AnyObject {
    
}

// MARK: - LanguagePresenterProtocol
protocol LanguagePresenterProtocol: AnyObject {
    init(view: LanguageViewProtocol, delegate: LanguageUpdatingDelegate?)
    func update(with language: String)
}

// MARK: - LanguagePresenter
final class LanguagePresenter: LanguagePresenterProtocol {
    weak var view: LanguageViewProtocol?
    weak var delegate: LanguageUpdatingDelegate?
    
    init(view: LanguageViewProtocol, delegate: LanguageUpdatingDelegate?) {
        self.view = view
        self.delegate = delegate
    }
    
    func update(with language: String) {
        delegate?.update(with: language)
    }
    
}
