//
//  AdministrarUsuariosViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 3/20/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//


import UIKit

class AdministrarUsuariosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var dataFiltered = [Any]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    
    var newArray:[Any]?
    
    
    override func viewDidLoad() {
        
        
        newArray = CurrentUserDB.currentUser.canModifyList
        //newArray = CurrentUserDB.currentUser.toName(arr: CurrentUserDB.currentUser.canModifyList!)
        print("new array: \(String(describing: newArray))")
        
        dataFiltered = newArray!
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
       
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
        self.tableView.reloadData()
        
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        print("data filtred: \(dataFiltered)")
        
        let s:String = dataFiltered[indexPath.row] as! String
        cell.textLabel?.text=s
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        var objectUser = String()
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "UserDetails") as! UserDetailsViewController
        //let nextView = self.storyboard?.instantiateViewController(withIdentifier: "UserDetailsEntrega") as! UserDetailsEntregaViewController
        //Verificar si la vista actual es la de búsqueda
        if (self.searchController.isActive) {
            index = indexPath.row
            objectUser = dataFiltered[index] as!  String
        } else {
            index = indexPath.row
            objectUser = newArray![index] as! String
        }
        
        print("this ID selected: \(objectUser)")
        //print("pushed to cel")

        nextView.userName = "XXXX"
        nextView.traceletID = objectUser
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        if searchController.searchBar.text! == "" {
            dataFiltered = newArray!
        } else {
            dataFiltered = newArray!.filter{
                print("$0: \($0)")
                //let objectUser=$0 as! [String:Any]
                let s:String = $0 as! String;
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))
                
            }
        }
        
        self.tableView.reloadData()
    }
    
}
