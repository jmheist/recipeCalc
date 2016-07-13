//
//  RecipeManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/7/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

let recipeMgr: RecipeManager = RecipeManager()

struct Recipe {
    
    var key = ""
    var author = ""
    var authorId = ""
    var name = ""
    var desc = ""
    var dateCreated = ""
    var dateEdited = ""
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
            dateCreated: String? = "",
            dateEdited: String? = "",
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
        self.dateCreated = dateCreated!
        self.dateEdited = dateEdited!
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
        rec["dateCreated"] = dateCreated
        rec["dateEdited"] = dateEdited
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
    
    func sortBy(sortBy: String, recipes: [Recipe]) -> [Recipe] {
        
        var recs = recipes
        
        switch sortBy {
        case "stars":
            recs.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.stars > recipe2.stars
            }
        case "favs":
            recs.sortInPlace {(recipe1:Recipe, recipe2:Recipe) -> Bool in
                recipe1.favCount > recipe2.favCount
            }
        default:
            break
        }
        
        return recs
    }
    
    func sendToFirebase (recipe: Recipe) -> String {
        
        if recipe.key == "" {
            let key = Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).childByAutoId().key
            Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).setValue(recipe.fb())
            return key
        } else {
            print("recipe has a key already, should update it with new data")
            Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(recipe.key).setValue(recipe.fb())
            
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
        let dateCreated = snapshot.value!["dateCreated"] as? String ?? ""
        let dateEdited = snapshot.value!["dateEdited"] as? String ?? ""
        let pg = snapshot.value!["pg"] as! String
        let vg = snapshot.value!["vg"] as! String
        let strength = snapshot.value!["strength"] as! String
        let steepDays = snapshot.value!["steepDays"] as! String
        let published = snapshot.value!["published"] as! String
        let stars = snapshot.value!["stars"] as! CGFloat
        let starsCount = snapshot.value!["starsCount"] as? Int ?? 0
        let favCount = snapshot.value!["favCount"] as? Int ?? 0
        let rec = Recipe(key: key, author: author, authorId: authorId, name: name, desc: desc, dateCreated: dateCreated, dateEdited: dateEdited, pg: pg, vg: vg, strength: strength, steepDays: steepDays, published: published, stars: stars, starsCount: starsCount, favCount: favCount)
        return rec
    }
    
    func deleteRecipe(key: String, completionHandler:([Recipe])->()) {
        
        analyticsMgr.sendRecipeDeleted()
        Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).removeValue()
        Queries.publicRecipes.child(key).removeValue()
        Queries.flavors.child(key).removeValue()
        
        getUserRecipes(AppState.sharedInstance.signedInUser.uid!, sort: "stars") { (recipes) in
            completionHandler(recipes)
        }

    }
    
    func publishRecipe(key: String, completionHandler:(Recipe)->()) {
        print("Publishing now from RecipeManager")
        
        //update on FB
        Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).child("published").setValue("true")
        Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            analyticsMgr.sendRecipePublished()
            let rec = self.receiveFromFirebase(snapshot)
            Queries.publicRecipes.child(key).setValue(rec.fb())
            completionHandler(rec)
        })
    }
    
    func unPublishRecipe(key: String, completionHandler:(Recipe)->()){
        print("UN-Publishing now from RecipeManager")
        
        // update on fb
        // delete public recipe
        Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).child("published").setValue("false")
        Queries.publicRecipes.child(key).setValue(nil)
        
        analyticsMgr.sendRecipeUnpublished()
        
        Queries.myRecipes.child(AppState.sharedInstance.signedInUser.uid!).child(key).observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            completionHandler(self.receiveFromFirebase(snapshot))
        })
        
    }
    
    func getUserPublishedRecipes(uid: String, sort: String, completionHandler:([Recipe])->()) {
        var publisheRecipes = [Recipe]()
        self.getUserRecipes(uid, sort: sort) { (recipes) in
            for rec in recipes {
                if rec.published == "true" {
                    publisheRecipes.append(rec)
                }
            }
            completionHandler(self.sortBy(sort, recipes: publisheRecipes))
        }
        
    }
    
    func getUserRecipes(uid: String, sort: String, completionHandler:([Recipe])->()) {
        
        var fetchedRecipes = [Recipe]()
        Queries.myRecipes.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for snap in snapshot.children {
                fetchedRecipes.append(self.receiveFromFirebase(snap as! FIRDataSnapshot))
            }
            completionHandler(self.sortBy(sort, recipes: fetchedRecipes))
        })
        
    }
    
    func getPublishedRecipes(sort: String, completionHandler:([Recipe])->()) {
        var fetchedRecipes = [Recipe]()
        Queries.publicRecipes.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for snap in snapshot.children {
                fetchedRecipes.append(self.receiveFromFirebase(snap as! FIRDataSnapshot))
            }
            completionHandler(self.sortBy(sort, recipes: fetchedRecipes))
        })
    }

}