//
//  ViewController.swift
//  TraceletApp
//
//  Created by José Alberto Jurado on 2/27/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "splashToLogin", sender: self)
    }


}

