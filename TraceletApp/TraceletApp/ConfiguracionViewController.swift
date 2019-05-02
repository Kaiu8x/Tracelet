//
//  ConfiguracionViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit

class ConfiguracionViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userMailLabel: UILabel!
    let cu = CurrentUserDB.self
    
    override func viewDidLoad() {
        
        updateLabel()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLabel()
    }
    
    func updateLabel () {
        
        print("Current user data 1")
        print(CurrentUserDB.currentUser.name)
        print(CurrentUserDB.currentUser.email)
        userNameLabel.text = CurrentUserDB.currentUser.name
        userMailLabel.text = CurrentUserDB.currentUser.email
        
    }
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        CurrentUserDB.currentUser.update()
        CurrentUserDB.currentUser.logOut()
        
        //self.performSegue(withIdentifier: "logOutSegue", sender: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToConfiguracion(sender: UIStoryboardSegue) {
        
    }

}
