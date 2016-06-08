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

var ref: FIRDatabaseReference = FIRDatabase.database().reference()


class Queries {
    
    static let sharedInstance = Queries()
    
    var myRecipes = ref.child("myRecipes").child((AppState.sharedInstance.uid! as String))
    var publicRecipes = ref.child("recipes")
    var flavors = ref.child("flavors")
}


