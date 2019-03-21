//
//  UserDetailsEntregaViewController2.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsEntrega2ViewController : UIViewController {
    
    var name:String="XXX"
    
    
    @IBOutlet weak var theName2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        theName2.text = name
        // Do any additional setup after loading the view.
    }
}
