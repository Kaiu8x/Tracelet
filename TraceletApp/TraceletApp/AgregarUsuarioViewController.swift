//
//  AgregarUsuarioViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/19/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit

class AgregarUsuarioViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var codigo: UITextField!
    @IBOutlet weak var guardarButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        //Codigo de asociar usuario posiblemente aqui
        
        if userExists(codigo.text!) {
            CurrentUserDB.currentUser.canModifyList?.append(codigo.text!)
            CurrentUserDB.currentUser.canViewList?.append(codigo.text!)
            print("nuevo codigo agregado a canModifyList: \(String(describing: CurrentUserDB.currentUser.canModifyList))")
            //let nextView = self.storyboard?.instantiateViewController(withIdentifier: "ConexionNuevoUsuario") as! ConexionNuevoUsuarioViewController
            
            //self.navigationController?.pushViewController(nextView, animated: true)
            
            self.performSegue(withIdentifier: "addUserSuccessSegue", sender: nil)
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func userExists(_ userId: String) -> Bool {
        
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
        nombre.delegate = self
        codigo.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateGuardarButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        guardarButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateGuardarButtonState()
        //navigationItem.title = textField.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: Private Methods
    
    private func updateGuardarButtonState() {
        // Disable the Save button if the text field is empty.
        let nom = nombre.text ?? ""
        let cod = codigo.text ?? ""
        var encendido = false
        if !nom.isEmpty && !cod.isEmpty{
            encendido = true
        }
        guardarButton.isEnabled = encendido
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
