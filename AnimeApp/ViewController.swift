//
//  ViewController.swift
//  AnimeApp
//
//  Created by Maxim Raskevich on 16.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var userService = UserService.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
//        userService.login(email: "test69@email.com", and: "1234.4321") { [weak self] result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let data):
//                let session = data as? Session
//                print(session)
//            }
//        }
        
        userService.registration(email: "t24eest2@gmail.com", username: "test6625", password: "63tmy6.53") { [weak self] result in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                if let jsonData = data as? [String: Any], let error = jsonData["detail"] as? String {
                    print(error)
                }
            }
            
        }
    }
}
