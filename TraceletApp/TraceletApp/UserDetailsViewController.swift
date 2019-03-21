//
//  UserDetailsViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsViewController : UIViewController {
    
    var userName:String = "XXX"
    var traceletID:String = "XXX"
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var traceletIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traceletIDLabel.text = "Tracelet: "+traceletID
        userNameLabel.text = userName
        // Do any additional setup after loading the view.
    }
}

