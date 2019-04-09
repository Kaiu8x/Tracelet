//
//  ShopViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/9/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation
import UIKit

class ShopViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var dataFiltered = [Any]()
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            dataFiltered = newArray!
        } else {
            dataFiltered = newArray!.filter{
                let objectUser=$0 as! [String:Any]
                let s:String = objectUser["name"] as! String;
                return(s.lowercased().contains(searchController.searchBar.text!.lowercased()))
                
            }
        }
        
        self.tableView.reloadData()
    }
    
    let dataUrl = "http://martinmolina.com.mx/201911/data/jsonTracelet/shop.json"
    
    var newArray:[Any]?
    
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
        
        let url = URL(string: dataUrl)
        let data = try? Data(contentsOf: url!)
        
        
        newArray = try! JSONSerialization.jsonObject(with: data!) as? [Any]
        print(newArray)
        dataFiltered = newArray!
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.hidesNavigationBarDuringPresentation = false
        
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopCell", for: indexPath)
        
        let objectUser = dataFiltered[indexPath.row] as! [String: Any]
        let s:String = objectUser["name"] as! String
        
        cell.textLabel?.text=s
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = 0
        var objectUser = [String:Any]()
        let nextView = self.storyboard?.instantiateViewController(withIdentifier: "ShopDetails") as! ShopDetailsViewController
        
        if (self.searchController.isActive)
        {
            index = indexPath.row
            objectUser = dataFiltered[index] as! [String: Any]
            
        }
            //sino utilizar la vista sin filtro
        else
        {
            index = indexPath.row
            objectUser = newArray![index] as! [String: Any]
        }
        
        let s:String = objectUser["name"] as! String
        let s2:String = objectUser["description"] as! String
        let s3:String = objectUser["imageUrl"] as! String
        let s4:String = objectUser["3dmodelUrl"] as! String

        nextView.traceletName = s
        nextView.traceletDescription = s2
        nextView.traceletImageUrl = s3
        nextView.tracelet3dModelUrl = s4
        
        self.navigationController?.pushViewController(nextView, animated: true)
    }

}

