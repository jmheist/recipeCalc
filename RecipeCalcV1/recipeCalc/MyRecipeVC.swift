//
//  MyRecipeVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/6/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class MyRecipeVC: RecipeVC {
    
    override func prepareView() {
        view.backgroundColor = colors.background
    }
    
    override func prepareNavigationItem() {
        
        navigationItem.title = "My Recipe"
        
        let publishButton: B3 = B3()
        publishButton.setTitle("Publish", forState: .Normal)
        publishButton.addTarget(self, action: #selector(publishRecipe), forControlEvents: .TouchUpInside)
        
        navigationItem.rightControls = [publishButton]
    }
    
    func publishRecipe(sender: UIButton) {
        let recipe = myRecipes[sender.tag]
        //////
        ////// Todo: 
        //////
        Queries.recipes.child(recipe.key).setValue(recipe.value)
    }
    
}
