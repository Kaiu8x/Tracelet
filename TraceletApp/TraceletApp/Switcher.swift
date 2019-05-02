//
//  Switcher.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/7/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootViewController(){
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootViewController : UIViewController?
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        print("status: ", status)
        
        if(status == true) {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "tabBar")
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "startViewController")
            //rootViewController = storyboard.instantiateInitialViewController()
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
    }
}
