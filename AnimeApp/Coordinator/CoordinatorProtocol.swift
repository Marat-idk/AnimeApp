//
//  CoordinatorProtocol.swift
//  AnimeApp
//
//  Created by Marat on 28.05.2023.
//

import UIKit

protocol FlowCoordinator {
    var completionHandler: ((Bool) -> Void)? { get set }
}

typealias CoordinatorHandler = () -> Void

// MARK: - CoordinatorProtocol
protocol CoordinatorProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    var flowCompletionHandler: CoordinatorHandler? { get }
    
    func start()
}
