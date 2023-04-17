//
//  ViewController.swift
//  AnimeApp
//
//  Created by Maxim Raskevich on 16.04.2023.
//

import UIKit

class ViewController: UIViewController {
    
    var networkManager = NetworkManagerImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red
        
        print(AuthorizationRequest.userCreate(email: "test@email.com", password: "1234.4321", username: "test").descriptionString)
        
        networkManager.request(with: AuthorizationRequest.userCreate(email: "test@emt3fbg3fail.com", password: "1234.4321", username: "tes3gveb4t")) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            print((response as? HTTPURLResponse)?.statusCode)
            
            print(data?.count)
        }
    }
}
