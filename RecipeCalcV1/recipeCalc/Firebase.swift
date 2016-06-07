//
//  Recipe.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/4/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import Foundation
import UIKit
import Firebase

var ref: FIRDatabaseReference!

var myRecipes: [FIRDataSnapshot]! = []
var recipes: [FIRDataSnapshot]! = []

struct Queries {
    static let myRecipes = ref.child("myRecipes")
    static let recipes = ref.child("recipes")
    static let flavors = ref.child("flavors")
}


///////
/////// Flavor stuff
///////

struct flavor {
    
    var name = ""
    var base = ""
    var pct = ""
    
}

class FlavorManager: NSObject {
    
    var flavors = [flavor]()
    
    func addFlavor(name: String, base: String, pct: String) -> Bool! {
        
        var newflavor = flavor()
        newflavor.name =  name
        newflavor.base = base
        newflavor.pct = pct
        
        flavors.append(newflavor)
        return true
    }
    
    func reset() {
        flavors.removeAll()
    }
    
}


