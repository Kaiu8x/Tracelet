//
//  TabBarController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class TabBarController: UITabBarController{
    let cu = CurrentUserDB.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(cu.name)
        print(cu.email)
        print(CurrentUserDB.currentUser.name)
        print(CurrentUserDB.currentUser.email)
    }
    
    
}
