//
//  CoordinatorProtocol.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

typealias CoordinatorHandler = () -> Void

// MARK: - CoordinatorProtocol
protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    var flowCompletionHandler: CoordinatorHandler? { get }
    
    func start()
}
