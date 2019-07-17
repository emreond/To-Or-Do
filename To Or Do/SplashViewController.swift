//
//  SplashViewController.swift
//  To Or Do Project
//
//  Created by Emre on 20.06.2019.
//  Copyright © 2019 Emre. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    private let splashImage: UIImageView = {
        let s = UIImageView()
        s.contentMode = .scaleAspectFit
        s.image = UIImage(named: "splashLogo")
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Colors.darkPurple
        splashImage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(splashImage)
        splashImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        splashImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        splashImage.anchorCenterSuperview()
    }
    override func viewDidAppear(_ animated: Bool) {
       
        let controller = MainViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
