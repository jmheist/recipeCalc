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
        let key = Queries.sharedInstance.myRecipes.childByAutoId().key
        Queries.sharedInstance.myRecipes.child(key).setValue(recipe.fb())
        return key
    }
    
    func removeRecipe(key: String) {
        let myIndex = myRecipeMgr.indexOfKey(key)
        let recipe = myRecipeMgr.recipes[myIndex]
        myRecipeMgr.recipes.removeAtIndex(myIndex)
        
        if recipe.published == "true" {
            publicRecipeMgr.recipes.removeAtIndex(publicRecipeMgr.indexOfKey(key))
        }

        Queries.sharedInstance.myRecipes.child(key).removeValue()
        Queries.sharedInstance.publicRecipes.child(key).removeValue()
        Queries.sharedInstance.flavors.child(key).removeValue()

    }
    
    func publishRecipe(key: String) -> Recipe {
        print("Publishing now from RecipeManager")
        
        //update locally
        let index = myRecipeMgr.indexOfKey(key)
        myRecipeMgr.recipes[index].published = "true"
        let recipe = myRecipeMgr.recipes[index]
        
        //update on FB
        Queries.sharedInstance.myRecipes.child(key).child("published").setValue("true")
        Queries.sharedInstance.publicRecipes.child(key).setValue(recipe.fb())
        
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
        Queries.sharedInstance.myRecipes.child(key).child("published").setValue("false")
        Queries.sharedInstance.publicRecipes.child(key).setValue(nil)
        
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
        print("checking for index")
        for recipe in self.recipes {
            print((recipe.key == key))
            if recipe.key == key {
                index = i
                print("index inside \(index)")
            }
            i += 1
        }
        print(index)
        return index as Int
    }    
}