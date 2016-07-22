//
//  FlavorManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/7/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

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
        var flav = [String:String]()
        flav["name"] = name
        flav["base"] = base
        flav["pct"] = pct
        flav["key"] = key
        return flav
    }
}

class FlavorManager: NSObject {
    
    var flavors = [Flavor]()
    
    func addFlavor(flavor: Flavor, isNewRecipe:Bool?=false) {
        if isNewRecipe! as Bool {
            analyticsMgr.sendFlavorAdded(flavor.name, pct: flavor.pct, base: flavor.base)
        }
        flavors.append(flavor)
    }
    
    func reset() {
        flavors.removeAll()
    }
    
    func sendToFirebase(key: String, flavors: [Flavor]) {
        for flavor in flavors {
            if flavor.key == "" {
                Queries.flavors.child(key).childByAutoId().setValue(flavor.fb())
            } else {
                Queries.flavors.child(key).child(flavor.key).setValue(flavor.fb())
            }
        }
    }
    
    func receiveFromFirebase(snapshot: FIRDataSnapshot) -> Flavor {
        let base = snapshot.value!["base"] as! String
        let name = snapshot.value!["name"] as! String
        let pct = snapshot.value!["pct"] as! String
        let flav = Flavor(name: name, base: base, pct: pct)
        return flav
    }
    
    func getFlavorsForRecipe(recipeId: String, completionManager:([Flavor])->()) {
        Queries.flavors.child(recipeId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var flavs = [Flavor]()
            for snap in snapshot.children {
                let snap = snap as! FIRDataSnapshot
                flavs.append(self.receiveFromFirebase(snap))
            }
            completionManager(flavs)
        })
    }
    
}