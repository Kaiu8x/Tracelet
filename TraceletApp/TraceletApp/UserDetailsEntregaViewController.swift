//
//  UserDetailsEntrega.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class UserDetailsEntregaViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var newArray2:[Any]?
    var newArray:[String]?
    var dataFiltered = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            dataFiltered = newArray!
        } else {
            dataFiltered = newArray!.filter{
                let objectUser=$0
                let s:String = objectUser ;
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))
                
            }
        }
        
        self.tableView.reloadData()
    }
    
    func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8) {
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            } catch {
                print("error")
                //handle errors here
            }
        }
        return [AnyObject]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newArray = newArray2 as? [String]
        print("new array")
        print(newArray)
        print("new array2")
        print(newArray2)
        dataFiltered = newArray!
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (dataFiltered.count) // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, numberOfSections : Int) -> Int {
        
        return 1 // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell2", for: indexPath)
        
        let objectUser = dataFiltered[indexPath.row]
        //let s:String = objectUser["name"] as! String
        
        cell.textLabel?.text=objectUser
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        var objectUser = String()
        //let nextView = self.storyboard?.instantiateViewController(withIdentifier: "UserDetails") as! UserDetailsViewController
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsEntrega2") as! UserDetailsEntrega2ViewController
        //Verificar si la vista actual es la de búsqueda
        if (self.searchController.isActive)
        {
            index = indexPath.row
            objectUser = dataFiltered[indexPath.row]
            
        }
            //sino utilizar la vista sin filtro
        else
        {
            index = indexPath.row
            objectUser = (newArray?[indexPath.row])!
        }
        let s:String = objectUser
        
        print(s)
        nextView.name = s
        //nextView.name = s
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }
}
