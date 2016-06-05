//
//  RecipeManager.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import RealmSwift

var recipeMGR: RecipeManager = RecipeManager()

class RecipeManager: NSObject {
    
    var recipes = realm.objects(Recipe)
    var recipeToEdit = 0
    var recipeToMix = 0
    
    func addRecipe(name: String, desc: String, pgPct: String, vgPct: String, flavors: [Flavor], id: Int?=0, view: UIViewController) -> Bool {
        
        let newRecipe = Recipe()
        newRecipe.name = name
        newRecipe.desc = desc
        newRecipe.pgPct = pgPct
        newRecipe.vgPct = vgPct
        newRecipe.id = id! > 0 ? id! : (recipes.count > 0  ? (recipes.last?.id)! + 1 : 1)
        
        if errorMGR.checkForErrors("recipe", view: view, recipe: newRecipe) { // true = it has errors
            return false // failed error check, did not add new recipe
        }
        
        
        newRecipe.flavors.appendContentsOf(flavors)
        
        
        print("Adding New Recipe ", newRecipe.id," ", newRecipe.name)
        
        if recipeToEdit == 0 {
            let newSettings = Settings()
            newSettings.mixAmount = "30"
            newSettings.nicStrength = "100"
            newSettings.nicBase = 0
            newSettings.nicTarget = "3"
            newSettings.pgStandardGrams = "1.038"
            newSettings.vgStandardGrams = "1.26"
            newSettings.nicStandardGrams = "1.01"
            newSettings.flavorStandardGrams = "1"
            newSettings.waterStandardGrams = "1"
            newRecipe.settings.append(newSettings)
        }
        
        try! realm.write {
            realm.add(newRecipe, update: true)
            recipeToEdit = 0
        }

        return true
    }
    
    func removeRecipe(recipe: Object) {
        try! realm.write {
            realm.delete(recipe)
        }
    }
    
    func getRecipeToEdit() -> Recipe {
        
        let recipe = realm.objects(Recipe).filter("id == \(recipeToEdit)").first
        return recipe!
        
    }
    
    func getRecipeToMix() -> Recipe {
        let recipe = realm.objects(Recipe).filter("id == \(recipeToMix)").first
        return recipe!
    }
    
    func updateSettings(recipe: Recipe, newSettings: Settings) {
        try! realm.write {
            recipe.settings.removeAll()
            recipe.settings.append(newSettings)
        }
    }
}


