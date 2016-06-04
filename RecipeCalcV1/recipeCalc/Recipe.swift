//
//  Recipe.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/4/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import Foundation

class Recipe: NSObject {
    var uid: String
    var creator: String
    var recipeName: String
    var recipeDesc: String
    
    init(uid: String?, creator: String, recipeName: String, recipeDesc: String) {
        self.uid = uid!
        self.creator = creator
        self.recipeName = recipeName
        self.recipeDesc = recipeDesc
    }
    
    convenience override init() {
        self.init(uid: "", creator: "", recipeName: "", recipeDesc:  "")
    }
}