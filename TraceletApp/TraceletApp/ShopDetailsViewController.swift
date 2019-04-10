//
//  ShopDetailsViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/9/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class ShopDetailsViewController : UIViewController {
    
    
    var traceletName = "XXX"
    var traceletDescription = "69"
    var traceletImageUrl = "XXX"
    var tracelet3dModelUrl = "69"

    
    @IBOutlet weak var traceletNameLabel: UILabel!
    @IBOutlet weak var traceletImageView: UIImageView!
    @IBOutlet weak var traceletDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        traceletNameLabel.text = traceletName
        traceletDescriptionLabel.text = traceletDescription
        let url = URL(string: traceletImageUrl)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        traceletImageView.image = UIImage(data: data!)
    }
    
}

