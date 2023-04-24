//
//  UIResponder+Helper.swift
//  AnimeApp
//
//  Created by Marat on 24.04.2023.
//

import UIKit

// MARK: - UIResponder extension
extension UIResponder {
    // нужно для динамического поднятия вью при появлении клавиатуры
    private struct Static {
        static weak var responder: UIResponder?
    }

    // Finds the current first responder
    // - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}
