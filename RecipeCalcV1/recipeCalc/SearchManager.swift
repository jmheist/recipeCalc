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
    
    func search(term: String, completionHandler:([Recipe])->()) {
        
        var flavorsComplete = false
        var recipesComplete = false
        
        func returnRes(search: String) {
            if search == "flavors" {
                flavorsComplete = true
            } else if search == "recipes" {
                recipesComplete = true
            }
            
            if flavorsComplete && recipesComplete {
                completionHandler(res)
            }
            
        }
        
        Queries.publicRecipes.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            for child in snapshot.children {
                let snap = child as! Dictionary<String,String>
                for (_, val) in snap {
                    if val.containsString(term) {
                        self.res.append(publicRecipeMgr.receiveFromFirebase(child as! FIRDataSnapshot))
                    }
                }
            }
            returnRes("recipes")
        })
        
        Queries.flavors.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            for child in snapshot.children {
                let child = child as! FIRDataSnapshot
                for recipe in child.children {
                    let flavor = recipe as! Dictionary<String,String>
                    for (_, val) in flavor {
                        if val.containsString(term) {
                            Queries.publicRecipes.child(child.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                self.res.append(publicRecipeMgr.receiveFromFirebase(snapshot))
                            })
                        }
                    }
                }
            }
            returnRes("flavors")
        })
        
    }
    
}
