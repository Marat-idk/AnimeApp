//
//  MainTabBarController.swift
//  AnimeApp
//
//  Created by Marat on 21.05.2023.
//

import UIKit

// MARK: - MainTabBarController
final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setupTabBarAppearance()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: ModuleBuilder.createAuthorizationModule(),
                title: "Profile",
                image: UIImage(named: "ic-profile")
            ),
            generateVC(
                viewController: ModuleBuilder.createPesonalMenuModule(),
                title: "Menu",
                image: UIImage(named: "ic-profile")?.template
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String?, image: UIImage?) -> UIViewController {
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        viewController.tabBarItem = tabBarItem
        let navVC = UINavigationController(rootViewController: viewController)
        return navVC
    }
    
    private func setupTabBarAppearance() {
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.tintColor = .brandLightBlue
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandBlue
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
