//
//  SearchManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/22/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Darwin

class SearchManager: NSObject {
    
    var reportedSearchTerm = ""
    
    var res = [Recipe]()
    
    func addRes(newRec: Recipe) {
        
        if res.indexOf({$0.name == newRec.name}) == nil {
            res.append(newRec)
        }
        
    }
    
    func reset() {
        res = [Recipe]()
    }
    
    func sortBy(sortBy: String) {
        switch sortBy {
        case "stars":
            self.res.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.stars > recipe2.stars
            }
        case "favs":
            self.res.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.favCount > recipe2.favCount
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
            
            func finish() {
                sortBy("stars")
                completionHandler(res)
                reportSearch(term)
            }
            
            if flavorsComplete && recipesComplete {
                finish()
            }
            
        }
        
        Queries.publicRecipes.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            for child in snapshot.children {
                let child = child as! FIRDataSnapshot
                let snap = recipeMgr.receiveFromFirebase(child)
                if snap.name.lowercaseString.containsString(term.lowercaseString) || snap.desc.lowercaseString.containsString(term.lowercaseString) {
                    self.addRes(snap)
                }
            }
            returnRes("recipes")
        })
        
        Queries.flavors.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in

            var recCount = 0
            var recReceivedCount = 0

            func timeToReturn() {
                setTimeout(1, block: {
                    returnRes("flavors")
                })
            }
            
            for child in snapshot.children {
                let child = child as! FIRDataSnapshot
                for flavor in child.children {
                    let flavor = flavorMgr.receiveFromFirebase(flavor as! FIRDataSnapshot)
                    if flavor.name.lowercaseString.containsString(term.lowercaseString) {
                        Queries.publicRecipes.child(child.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            self.addRes(recipeMgr.receiveFromFirebase(snapshot))
                        })
                        break
                    }
                }
                timeToReturn()
            }
        })
        
    }
    
    func reportSearch(term: String) {
        if term != reportedSearchTerm {
            reportedSearchTerm = term
            setTimeout(3) {
                print("search reported: \(self.reportedSearchTerm)")
                analyticsMgr.sendSearchEvent(self.reportedSearchTerm)
            }
        }
    }
    
}
