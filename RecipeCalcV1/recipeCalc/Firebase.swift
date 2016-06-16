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


struct Queries {
    
    static let myRecipes = ref.child("myRecipes")
    static let publicRecipes = ref.child("recipes")
    static let flavors = ref.child("flavors")
    static let ratings = ref.child("ratings")
    
}


