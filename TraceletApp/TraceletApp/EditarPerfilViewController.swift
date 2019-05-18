//
//  EditarPerfilViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/19/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit

class EditarPerfilViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var userNameTextFielf: UITextField!
    @IBOutlet weak var userMailTextField: UITextField!
    @IBOutlet weak var userDeviceId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelText()
        //scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height+500)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
        
        if CurrentUserDB.currentUser.email != userMailTextField.text! {
            let s = userMailTextField.text!
            CurrentUserDB.currentUser.updateAuthEmail(s: s)
            CurrentUserDB.currentUser.email = s
        }
        
        
        CurrentUserDB.currentUser.deviceId = userDeviceId.text!
        print("Guardar current user")
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @objc func Keyboard(notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
