//
//  SearchManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/22/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

class SearchManager: NSObject {
    
    var res = [Recipe]()
    
    func reset() {
        res = [Recipe]()
    }
    
    func sortBy(sortBy: String) {
        switch sortBy {
        case "stars":
            self.res.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.stars > recipe2.stars
            }
        default:
            break
        }
        
    }
    
    func search(term: String, completionHandler:([Recipe])->()) {
        
        reset()
        
        let flavorMgr: FlavorManager = FlavorManager()
        
        var flavorsComplete = false
        var recipesComplete = false
        
        func returnRes(search: String) {
            if search == "flavors" {
                flavorsComplete = true
            } else if search == "recipes" {
                recipesComplete = true
            }
            
            if flavorsComplete && recipesComplete {
                sortBy("stars")
                completionHandler(res)
            }
            
        }
        
        Queries.publicRecipes.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            for child in snapshot.children {
                let child = child as! FIRDataSnapshot
                let snap = publicRecipeMgr.receiveFromFirebase(child)
                if snap.name.containsString(term) {
                    self.res.append(snap)
                } else if snap.desc.lowercaseString.containsString(term.lowercaseString) {
                    self.res.append(snap)
                }
            }
            returnRes("recipes")
        })
        
        Queries.flavors.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            for child in snapshot.children {
                let child = child as! FIRDataSnapshot
                for flavor in child.children {
                    let flavor = flavorMgr.receiveFromFirebase(flavor as! FIRDataSnapshot)
                    if flavor.name.lowercaseString.containsString(term.lowercaseString) {
                        Queries.publicRecipes.child(child.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            self.res.append(publicRecipeMgr.receiveFromFirebase(snapshot))
                        })
                    }
                }
            }
            returnRes("flavors")
        })
        
    }
    
}
