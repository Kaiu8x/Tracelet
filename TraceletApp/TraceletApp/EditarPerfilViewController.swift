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
    @IBOutlet weak var userDeviceId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
        // Do any additional setup after loading the view.
    }
    
    func setLabelText() {
        userNameTextFielf.text = CurrentUserDB.currentUser.name
        userMailTextField.text = CurrentUserDB.currentUser.email
        userDeviceId.text = CurrentUserDB.currentUser.deviceId
    }
    
    @IBAction func guardar(_ sender: UIButton) {
        //Codigo para gaurdar cambios del perfil del usuario
        CurrentUserDB.currentUser.name = userNameTextFielf.text!
        CurrentUserDB.currentUser.email = userMailTextField.text!
        CurrentUserDB.currentUser.deviceId = userDeviceId.text!
        print("Guardar")
        print(CurrentUserDB.currentUser.name)
        print(CurrentUserDB.currentUser.email)
        print(CurrentUserDB.currentUser.deviceId)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
