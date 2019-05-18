//
//  AgregarUsuarioViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/19/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import Firebase

class AgregarUsuarioViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var codigo: UITextField!
    @IBOutlet weak var guardarButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func guardar(_ sender: UIBarButtonItem) {
        //Codigo de asociar usuario posiblemente aqui
        userExists(codigo.text!)
        
    }
    
    func userExists(_ userMail: String) {
        if Auth.auth().currentUser != nil {
            let userAuth = Auth.auth().currentUser
            let db = Firestore.firestore()
            
            let docRef = db.collection("users").document(userMail)
            
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")

                    CurrentUserDB.currentUser.canModifyList?.append(userMail)
                    CurrentUserDB.currentUser.canViewList?.append(userMail)
                    print("nuevo codigo agregado a canModifyList: \(String(describing: CurrentUserDB.currentUser.canModifyList))")
                    
                    self.performSegue(withIdentifier: "addUserSuccessSegue", sender: nil)
                } else {
                    print("Document does not exist")
                    let alertController = UIAlertController(title: "Error", message: "User not found", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Auth Error", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
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
