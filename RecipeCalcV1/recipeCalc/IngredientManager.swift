//
//  IngredientManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/10/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

struct Ingredient {
    
    var type = ""
    var name = ""
    var ml = ""
    var grams = ""
    var pct = ""
    
    init(type: String, name: String, ml: String, grams: String, pct: String) {
        self.type = type
        self.name = name
        self.ml = ml
        self.grams = grams
        self.pct = pct
    }
    
}

class IngredientManager: NSObject {
    
    var ingredients = [Ingredient]()
    
    // turn these into Ingredients and return [Ingredients]
    
    var settings: MixSettings!
    let weightSettings: WeightSettings = WeightSettings()
    
    var flavors = [Flavor]()
    
    func setup(newSettings: MixSettings) {
        settings = newSettings
        updateMix()
    }
    
    func addFlavor(flavor: Flavor) {
        self.flavors.append(flavor)
        updateMix()
    }
    
    func updateMix() {
        
        ingredients = []
        var remainingVg = settings.amount * (settings.vg / 100)
        var remainingPg = settings.amount * (settings.pg / 100)
        
        var flavorIngredients = [Ingredient]()
        var baseIngredients = [Ingredient]()
        
        // go through flavors
        for flavor in flavors {
            let flavorAmount = settings.amount * (Float(flavor.pct)!/100)
            flavorIngredients.append(
                Ingredient(
                    type: "flavor",
                    name: flavor.name,
                    ml: String(format: "%.2f", flavorAmount),
                    grams: String(format: "%.2f", flavorAmount * weightSettings.flavorWeight),
                    pct: String(format: "%.2f", (flavorAmount / settings.amount) * 100)
                )
            )
            if flavor.base == "PG" {
                remainingPg = remainingPg - flavorAmount
            } else {
                remainingVg = remainingVg - flavorAmount
            }
        }
        
        // go through bases
        // VG, PG, NIC
        
        // PG
        baseIngredients.append(
            Ingredient(
                type: "base",
                name: "PG",
                ml: String(format: "%.2f", remainingPg),
                grams: String(format: "%.2f", remainingPg * weightSettings.pgWeight),
                pct: String(format: "%.2f", (remainingPg / settings.amount) * 100)
            )
        )
        
        // VG
        baseIngredients.append(
            Ingredient(
                type: "base",
                name: "VG",
                ml: String(format: "%.2f", remainingVg),
                grams: String(format: "%.2f", remainingVg * weightSettings.vgWeight),
                pct: String(format: "%.2f", (remainingVg / settings.amount) * 100)
            )
        )
        
        // NIC (Desired Strength(mg) / Concentrated Nicotine Strength(mg)) x Bottle size(ml) = Amount needed (ml)
        let nicAmount = (settings.strength/settings.nic)*settings.amount
        baseIngredients.append(
            Ingredient(
                type: "base",
                name: "Nicotine",
                ml: String(format: "%.2f", nicAmount),
                grams: String(format: "%.2f", nicAmount * weightSettings.nicWeight),
                pct: String(format: "%.2f", (nicAmount / settings.amount) * 100)
            )
        )
        
        // combine the 2 arrays
        ingredients.appendContentsOf(baseIngredients)
        ingredients.appendContentsOf(flavorIngredients)
        
    }
    
}
