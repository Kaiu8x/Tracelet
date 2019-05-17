//
//  StartViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func toLoginButton(_ sender: Any) {
        
            print("toLoginButton pushed")
        self.performSegue(withIdentifier: "toLoginSegue", sender: nil)
    }
    
    @IBAction func toSignupButton(_ sender: Any) {
            print("toSignupButton pushed")
        self.performSegue(withIdentifier: "toSignupSegue", sender: nil)
    }
    
}
