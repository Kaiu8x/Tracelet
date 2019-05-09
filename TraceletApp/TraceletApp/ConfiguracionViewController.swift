//
//  ConfiguracionViewController.swift
//  TraceletApp
//
//  Created by kenyiro tsuru on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import UIKit
import Firebase

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
        
        //let user = Auth.auth().currentUser!
        //let onlineRef = Database.database().reference(withPath: "online/\(user.email)")
        /*
        onlineRef.removeValue { (error, _) in
    
            if let error = error {
                print("Removing online failed: \(error)")
                return
            }
            
            do {
                try Auth.auth().signOut()
                
            } catch (let error) {
                print("Auth sign out failed: \(error)")
            }
        }
        */
        
        let firebaseAuth = Auth.auth()
        do {
            print("signOut2 success")
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "startViewController")
        self.navigationController?.popToRootViewController(animated: true)
        
        
        /*do {
            try Auth.auth().signOut()
            CurrentUserDB.currentUser.name = "nil"
            CurrentUserDB.currentUser.email = "nil"
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "startViewController")
            self.navigationController?.popToRootViewController(animated: true)
            
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }
        */
        //self.performSegue(withIdentifier: "logOutSegue", sender: nil)
        //self.navigationController?.popToRootViewController(animated: true)
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.window?.rootViewController = storyboard!.instantiateViewController(withIdentifier: "startViewController")
        
        //self.navigationController?.popToRootViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
        //let nextView = self.storyboard?.instantiateViewController(withIdentifier: "startViewController") as! StartViewController
        //self.navigationController?.popToViewController(nextView, animated: true)
       // self.navigationController?.pushViewController(nextView, animated: true)
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
