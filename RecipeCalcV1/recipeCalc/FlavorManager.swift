//
//  FlavorManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/7/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

struct Flavor {
    
    var name = ""
    var base = ""
    var pct = ""
    
    init(name: String, base: String, pct: String) {
        self.name = name
        self.base = base
        self.pct = pct
    }
    
}

class FlavorManager: NSObject {
    
    var flavors = [Flavor]()
    
    func addFlavor(flavor: Flavor) {
        flavors.append(flavor)
    }
    
    func reset() {
        flavors.removeAll()
    }
    
    func sendToFirebase(key: String) {
        for flavor in flavors {
            Queries.sharedInstance.flavors.child(key).childByAutoId().setValue(flavor as? AnyObject)
        }
    }
    
}