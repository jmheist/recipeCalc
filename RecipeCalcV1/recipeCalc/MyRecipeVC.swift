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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDatabase()
    }
    
    override func viewDidAppear(animated: Bool) {
        preparePublishButton()
    }
    
    deinit {
        
    }
    
    func prepareDatabase() {
        
    }
    
    override func prepareView() {
        view.backgroundColor = colors.background
    }
    
    override func prepareNavigationItem() {
        navigationItem.title = recipe.name
        preparePublishButton()
    }
    
    func publishRecipe() {
        recipeMgr.publishRecipe(self.recipe.key) { (rec) in
            self.recipe = rec
            self.preparePublishButton()
        }
    }
    
    func unPublishRecipe() {
        recipeMgr.unPublishRecipe(self.recipe.key, completionHandler: { (rec) in
            self.recipe = rec
            self.preparePublishButton()
        })
    }
    
    func preparePublishButton() {
        
        let publishButton = UIBarButtonItem(title: "Publish", style: .Plain, target: self, action: #selector(publishRecipe))
        
        if recipe.published == "true" {
            publishButton.title = "Unpublish"
            publishButton.action = #selector(unPublishRecipe)
        } else {
            publishButton.title = "Publish"
            publishButton.action = #selector(publishRecipe)
        }
        
        navigationItem.rightBarButtonItems = [publishButton]
        
    }
    
    override func prepareTabBar() {
        
        let tabBar = MixTabBar()
        
        view.addSubview(tabBar)
        Layout.height(view, child: tabBar, height: 40)
        Layout.bottom(view, child: tabBar, bottom: 0)
        Layout.horizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Mix", forState: .Normal)
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Edit", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(nil, action: #selector(editRecipe), forControlEvents: .TouchUpInside)
        
        let notesBtn: FlatButton = FlatButton()
        notesBtn.pulseColor = colors.medium
        notesBtn.setTitle("Notes", forState: .Normal)
        notesBtn.setTitleColor(colors.text, forState: .Normal)
        notesBtn.addTarget(nil, action: #selector(gotoNotes), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn2, notesBtn, btn1]
        
    }
    
    func editRecipe() {
        AppState.sharedInstance.recipe = recipe
        navigationController?.pushViewController(CreateRecipeViewController(), animated: true)
    }
    
    func gotoNotes() {
        navigationController?.pushViewController(NotesVC(recipe: recipe), animated: true)
    }
    
}
