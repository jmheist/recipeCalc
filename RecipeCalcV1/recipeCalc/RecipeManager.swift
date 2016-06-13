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
        
        if recipe.key == "" {
            let key = Queries.myRecipes.child(AppState.sharedInstance.uid!).childByAutoId().key
            Queries.myRecipes.child(AppState.sharedInstance.uid!).child(key).setValue(recipe.fb())
            return key
        } else {
            Queries.myRecipes.child(AppState.sharedInstance.uid!).child(recipe.key).setValue(recipe.fb())
            return recipe.key
        }
    }
    
    func removeRecipe(key: String) {
        let myIndex = myRecipeMgr.indexOfKey(key)
        let recipe = myRecipeMgr.recipes[myIndex]
        myRecipeMgr.recipes.removeAtIndex(myIndex)
        
        if recipe.published == "true" {
            let pubIndex = publicRecipeMgr.indexOfKey(key)
            if pubIndex > -1 {
                publicRecipeMgr.recipes.removeAtIndex(pubIndex)
            }
        }

        Queries.myRecipes.child(AppState.sharedInstance.uid!).child(key).removeValue()
        Queries.publicRecipes.child(key).removeValue()
        Queries.flavors.child(key).removeValue()

    }
    
    func publishRecipe(key: String) -> Recipe {
        print("Publishing now from RecipeManager")
        
        //update locally
        let index = myRecipeMgr.indexOfKey(key)
        myRecipeMgr.recipes[index].published = "true"
        let recipe = myRecipeMgr.recipes[index]
        
        //update on FB
        Queries.myRecipes.child(AppState.sharedInstance.uid!).child(key).child("published").setValue("true")
        Queries.publicRecipes.child(key).setValue(recipe.fb())
        
        // return updated recipe
        return recipe
    }
    
    func unPublishRecipe(key: String) -> Recipe {
        print("UN-Publishing now from RecipeManager")
        
        //update locally
        let index = myRecipeMgr.indexOfKey(key)
        myRecipeMgr.recipes[index].published = "false"
        let recipe = myRecipeMgr.recipes[index]
        
        let pubIndex = publicRecipeMgr.indexOfKey(key)
        if pubIndex > -1 {
            publicRecipeMgr.recipes.removeAtIndex(pubIndex)
        }
        
        // update on fb
        // delete public recipe
        Queries.myRecipes.child(AppState.sharedInstance.uid!).child(key).child("published").setValue("false")
        Queries.publicRecipes.child(key).setValue(nil)
        
        // return udated recipe
        return recipe
    }
    
    func removeRecipeAtIndex(index: Int) {
        self.recipes.removeAtIndex(index)
    }
    
    func updateRecipeAtIndex(index: Int, name: String, value: String) {
        
    }
    
    func indexOfKey(key: String) -> Int {
        var i = 0
        var index = -1
        for recipe in self.recipes {
            if recipe.key == key {
                index = i
            }
            i += 1
        }
        return Int(index)
    }    
}