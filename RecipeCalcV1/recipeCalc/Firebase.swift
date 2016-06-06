//
//  Recipe.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/4/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import Foundation
import Firebase

var ref: FIRDatabaseReference!

var myRecipes: [FIRDataSnapshot]! = []
var recipes: [FIRDataSnapshot]! = []

struct Queries {
    static let myRecipes = ref.child("myRecipes")
    static let recipes = ref.child("recipes")
}