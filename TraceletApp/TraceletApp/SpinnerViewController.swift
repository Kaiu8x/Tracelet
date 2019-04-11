//
//  SpinnerViewController.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 4/11/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//
import Foundation
import UIKit
class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

