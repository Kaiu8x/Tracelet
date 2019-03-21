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

}
