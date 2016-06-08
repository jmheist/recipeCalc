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
    
    var _refPublishedHandle: FIRDatabaseHandle!
    let publishButton: B3 = B3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatabase()
    }
    
    deinit {
        Queries.sharedInstance.myRecipes.child(recipe.key).removeObserverWithHandle(_refPublishedHandle)
    }
    
    func prepareDatabase() {
        // Listen for new messages in the Firebase database
        _refPublishedHandle = Queries.sharedInstance.myRecipes.child(recipe.key).observeEventType(.ChildChanged, withBlock: { (snapshot) -> Void in
            print("MyRecipeVC: Child Changed: Key \(snapshot.key)", "Value: \(snapshot.value)")
            self.preparePublishButton()
        })
    }
    
    override func prepareView() {
        view.backgroundColor = colors.background
    }
    
    override func prepareNavigationItem() {
        navigationItem.title = "My Recipe"
        preparePublishButton()
    }
    
    func publishRecipe(sender: UIButton) {
        self.recipe = myRecipeMgr.publishRecipe(recipe.key)
    }
    
    func unPublishRecipe(sender: UIButton) {
        self.recipe = myRecipeMgr.unPublishRecipe(recipe.key)
    }
    
    func preparePublishButton() {
        print(recipe)
        if recipe.published == "true" {
            print("Recipe is Published")
            publishButton.setTitle("Un-Publish", forState: .Normal)
            publishButton.addTarget(self, action: #selector(unPublishRecipe), forControlEvents: .TouchUpInside)
        } else {
            print("Recipe is not Published")
            publishButton.setTitle("Publish", forState: .Normal)
            publishButton.addTarget(self, action: #selector(publishRecipe), forControlEvents: .TouchUpInside)
        }
        
        navigationItem.rightControls = [publishButton]
    }
}
