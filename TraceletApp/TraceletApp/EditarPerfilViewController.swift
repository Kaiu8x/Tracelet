//
//  EditarPerfilViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/19/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit

class EditarPerfilViewController: UIViewController {

    @IBOutlet weak var userNameTextFielf: UITextField!
    @IBOutlet weak var userMailTextField: UITextField!
    @IBOutlet weak var userPwTextField: UITextField!
    
    
    
    @IBAction func guardar(_ sender: UIButton) {
        //Codigo para gaurdar cambios del perfil del usuario
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
