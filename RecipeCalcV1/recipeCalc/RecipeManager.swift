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
let recipeManager: RecipeManager = RecipeManager()

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
    var stars: CGFloat!
    var starsCount: Int!
    var favCount: Int!
    
    init(   key: String? = "",
            author: String? = "",
            authorId: String? = "",
            name: String? = "",
            desc: String? = "",
            pg: String? = "",
            vg: String? = "",
            strength: String? = "",
            steepDays: String? = "",
            published: String? = "false",
            stars: CGFloat?=0,
            starsCount: Int?=0,
            favCount: Int?=0
        )
    {
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
        self.stars = stars!
        self.starsCount = starsCount
        self.favCount = favCount
    }
    
    func fb() -> AnyObject {
        var rec = [String:AnyObject]()
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
        rec["stars"] = stars
        rec["starsCount"] = starsCount
        rec["favCount"] = favCount
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
    
    func sortBy(sortBy: String) {
        switch sortBy {
        case "stars":
            self.recipes.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.stars > recipe2.stars
            }
        case "favs":
            self.recipes.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.favCount > recipe2.favCount
            }
        default:
            break
        }
        
    }
    
    func sendToFirebase (recipe: Recipe) -> String {
        
        if recipe.key == "" {
            let key = Queries.myRecipes.child(AppState.sharedInstance.uid!).childByAutoId().key
            Queries.myRecipes.child(AppState.sharedInstance.uid!).child(key).setValue(recipe.fb())
            return key
        } else {
            print("recipe has a key already, should update it with new data")
            Queries.myRecipes.child(AppState.sharedInstance.uid!).child(recipe.key).setValue(recipe.fb())
            
            if recipe.published == "true" {
                Queries.publicRecipes.child(recipe.key).setValue(recipe.fb())
            }
            
            return recipe.key
        }
    }
    
    func receiveFromFirebase(snapshot: FIRDataSnapshot) -> Recipe {
        let key = snapshot.key as String
        let author = snapshot.value!["author"] as! String
        let authorId = snapshot.value!["authorId"] as! String
        let name = snapshot.value!["name"] as! String
        let desc = snapshot.value!["desc"] as! String
        let pg = snapshot.value!["pg"] as! String
        let vg = snapshot.value!["vg"] as! String
        let strength = snapshot.value!["strength"] as! String
        let steepDays = snapshot.value!["steepDays"] as! String
        let published = snapshot.value!["published"] as! String
        let stars = snapshot.value!["stars"] as! CGFloat
        let starsCount = snapshot.value!["starsCount"] as? Int ?? 0
        let favCount = snapshot.value!["favCount"] as? Int ?? 0
        let rec = Recipe(key: key, author: author, authorId: authorId, name: name, desc: desc, pg: pg, vg: vg, strength: strength, steepDays: steepDays, published: published, stars: stars, starsCount: starsCount, favCount: favCount)
        return rec
    }
    
    func updateRecipe(recipe: Recipe) {
        
        print("update called, \(recipe)")
        let myIndex = myRecipeMgr.indexOfKey(recipe.key)
        self.recipes[myIndex] = recipe
        
        if recipe.published == "true" {
            Queries.publicRecipes.child(recipe.key).setValue(recipe.fb())
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
        analyticsMgr.sendRecipeDeleted()
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
        
        analyticsMgr.sendRecipePublished()
        
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
        
        analyticsMgr.sendRecipeUnpublished()
        
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
    
    func getUserPublishedRecipes(uid: String, completionHandler:([Recipe])->()) {
        var fetchedRecipes = [Recipe]()
        Queries.myRecipes.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for snap in snapshot.children {
                let snap = self.receiveFromFirebase(snap as! FIRDataSnapshot)
                if snap.published == "true" {
                    fetchedRecipes.append(snap)
                }
            }
            completionHandler(fetchedRecipes)
        })
    }
    
}