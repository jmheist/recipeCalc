//
//  RecipeManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/7/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

let myRecipeMgr: RecipeManager = RecipeManager()
let publicRecipeMgr: RecipeManager = RecipeManager()

struct Recipe {
    
    var key = ""
    var author = ""
    var authorId = ""
    var name = ""
    var desc = ""
    var pg = ""
    var vg = ""
    var strength = ""
    var steepDays = ""
    var published = ""
    
    init(key: String? = "", author: String? = "", authorId: String? = "", name: String? = "", desc: String? = "", pg: String? = "", vg: String? = "", strength: String? = "", steepDays: String? = "", published: String? = "false") {
        self.key = key!
        self.author = author!
        self.authorId = authorId!
        self.name = name!
        self.desc = desc!
        self.pg = pg!
        self.vg = vg!
        self.strength = strength!
        self.steepDays = steepDays!
        self.published = published!
    }
    
    func fb() -> AnyObject {
        var rec = [String:String]()
        rec["key"] = key
        rec["author"] = author
        rec["authorId"] = authorId
        rec["name"] = name
        rec["desc"] = desc
        rec["pg"] = pg
        rec["vg"] = vg
        rec["strength"] = strength
        rec["steepDays"] = steepDays
        rec["published"] = published
        return rec
    }
    
}

class RecipeManager: NSObject {
    
    var recipes = [Recipe]()
    
    func addRecipe(recipe: Recipe) {
        recipes.append(recipe)
    }
    
    func reset() {
        recipes.removeAll()
    }
    
    func sendToFirebase (recipe: Recipe) -> String {
        let key = Queries.myRecipes.childByAutoId().key
        Queries.myRecipes.child(key).setValue(recipe.fb())
        return key
    }
    
    func removeRecipe(key: String) {
        myRecipeMgr.recipes.removeAtIndex(self.indexOfKey(key))
        publicRecipeMgr.recipes.removeAtIndex(publicRecipeMgr.indexOfKey(key))
        Queries.myRecipes.child(key).removeValue()
        Queries.publicRecipes.child(key).removeValue()
        Queries.flavors.child(key).removeValue()

    }
    
    func publishRecipe(key: String) {
        print("Publishing now from RecipeManager")
        let index = self.indexOfKey(key)
        var recipe = self.recipes[index]
        Queries.publicRecipes.child(key).setValue(recipe.fb())
        Queries.myRecipes.child(key).child("published").setValue("true")
        recipe.published = "true"
    }
    
    func unPublishRecipe(key: String) {
        print("UN-Publishing now from RecipeManager")
        Queries.publicRecipes.child(key).setValue(nil)
        Queries.myRecipes.child(key).child("published").setValue("false")
        myRecipeMgr.updateRecipeAtIndex(self.indexOfKey(key), name: "published", value: "false")
        publicRecipeMgr.removeRecipeAtIndex(publicRecipeMgr.indexOfKey(key))
    }
    
    func removeRecipeAtIndex(index: Int) {
        self.recipes.removeAtIndex(index)
    }
    
    func updateRecipeAtIndex(index: Int, name: String, value: String) {
        
    }
    
    func indexOfKey(key: String) -> Int {
        var i = 0
        for recipe in self.recipes {
            if recipe.key == key {
                return i
            }
            i += 1
        }
        return -1
    }    
}