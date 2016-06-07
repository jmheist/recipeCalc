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
        Queries.myRecipes.child(recipe.key).removeObserverWithHandle(_refPublishedHandle)
    }
    
    func prepareDatabase() {
        // Listen for new messages in the Firebase database
        _refPublishedHandle = Queries.myRecipes.child(recipe.key).observeEventType(.ChildChanged, withBlock: { (snapshot) -> Void in
            print("Key \(snapshot.key)", "Value: \(snapshot.value)")
            myRecipeMgr.updateRecipeAtIndex(myRecipeMgr.indexOfKey(self.recipe.key), name: snapshot.key, value: snapshot.value as! String!)
            if snapshot.key == "published" {
                print("should change publish button!")
            }
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
        myRecipeMgr.publishRecipe(recipe.key)
    }
    
    func unPublishRecipe(sender: UIButton) {
        myRecipeMgr.unPublishRecipe(recipe.key)
    }
    
    func preparePublishButton() {
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
