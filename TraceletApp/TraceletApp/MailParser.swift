//
//  MailParser.swift
//  TraceletApp
//
//  Created by Kai Kawasaki Ueda on 5/10/19.
//  Copyright © 2019 Kai Kawasaki Ueda. All rights reserved.
//

import Foundation

class MailParser {
    
    init() {
        
    }
    
    func encode(_ s: String) -> String{
        var res = s
        res = res.replacingOccurrences(of: ".", with: ",");
        res = res.replacingOccurrences(of: "#", with: "_numSign");
        res = res.replacingOccurrences(of: "$", with: "_dolSign");
        res = res.replacingOccurrences(of: "[", with: "_leftBrack");
        res = res.replacingOccurrences(of: "]", with: "_rightBrack");
        return res
    }
    
    func decode(_ s: String) -> String{
        var res = s
        res = res.replacingOccurrences(of: ",", with: ".");
        res = res.replacingOccurrences(of: "_numSign", with: "_numSign");
        res = res.replacingOccurrences(of: "_dolSign", with: "$");
        res = res.replacingOccurrences(of: "_leftBrack", with: "[");
        res = res.replacingOccurrences(of: "_rightBrack", with: "]");
        return res
        
    }
}
