//
//  ErrorManager.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit

struct flavor {
    
    var name = ""
    var base = 0
    var pct = ""
    
}

let flavorMGR: FlavorManager = FlavorManager()

class FlavorManager: NSObject {
    
    var flavors = [Flavor]()
    
    func addFlavor(name: String, base: Int, pct: String, view: UIViewController) -> Bool {
        
        let newflavor = Flavor()
        newflavor.name =  name
        newflavor.base = base
        newflavor.pct = pct
        
        if errorMGR.checkForErrors("flavor", view: view, flavor: newflavor) {
            return false
        }
        
        flavors.append(newflavor)
        return true
    }
    
    func reset() {
        flavors.removeAll()
    }
    
}


