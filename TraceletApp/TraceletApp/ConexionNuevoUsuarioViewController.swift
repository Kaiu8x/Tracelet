//
//  ConexionNuevoUsuarioViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/19/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import os.log

class ConexionNuevoUsuarioViewController: UIViewController {
    // var usuario: Usuario?  AQUI se declara un usuario nuevo que se guarda cuando le das a done
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button === doneButton else {
            os_log("The done button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        /*let nombre =
        let email =
        let id =
        
        // Guardar un nuevo usuario por los datos que se obtienen
        usuario = User(nombre: nombre, email: email, ID: id) */

    }
    

}
