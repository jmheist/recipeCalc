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
    var key = ""
    
    init(name: String, base: String, pct: String, key: String?="") {
        self.name = name
        self.base = base
        self.pct = pct
        self.key = key!
    }
    
    func fb() -> AnyObject {
        var rec = [String:String]()
        rec["name"] = name
        rec["base"] = base
        rec["pct"] = pct
        rec["key"] = key
        return rec
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
    
    func sendToFirebase(key: String, flavors: [Flavor]) {
        for flavor in flavors {
            Queries.sharedInstance.flavors.child(key).childByAutoId().setValue(flavor.fb())
        }
    }
    
}