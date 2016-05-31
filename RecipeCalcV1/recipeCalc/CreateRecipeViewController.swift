//
//  CreateRecipeViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class CreateRecipeViewController: UIViewController {
    
    // text fields
    
    private var recipeName: TextField!;
    private var recipeDesc: TextField!;
    private var recipePgPct: TextField!;
    private var recipeVgPct: TextField!;
    private var recipeSteepDays: TextField!;
    private var addFlavorName: TextField!;
    private var addFlavorBase: MaterialSwitch!;
    private var addFlavorPct: TextField!;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTitlebar()
        prepareTextFields()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.lightGrey
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create"
        tabBarItem.image = MaterialIcon.add
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "Create a Recipe"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let recipeInfo: MaterialView = MaterialView()
        recipeInfo.backgroundColor = colors.lightGrey
        view.addSubview(recipeInfo)
        
        MaterialLayout.height(view, child: recipeInfo, height: 165)
        MaterialLayout.alignFromTop(view, child: recipeInfo, top: 60)
        MaterialLayout.alignToParentHorizontally(view, child: recipeInfo, left: 14, right: 14)
        
        // recipe info fields
        
        recipeName = TextField()
        recipeName.placeholder = "Recipe Name"
        recipeName.font = RobotoFont.regularWithSize(24)
        recipeName.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeName)
        MaterialLayout.height(recipeInfo, child: recipeName, height: 28)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 25)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName, left: 10, right: 10)
        
        recipeDesc = TextField()
        recipeDesc.placeholder = "Recipe Description"
        recipeDesc.font = RobotoFont.regularWithSize(20)
        recipeDesc.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeDesc)
        MaterialLayout.height(recipeInfo, child: recipeDesc, height: 20)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 80)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc, left: 10, right: 10)
        
        recipePgPct = TextField()
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.font = RobotoFont.regularWithSize(14)
        recipePgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipePgPct)
        MaterialLayout.size(recipeInfo, child: recipePgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipePgPct, left: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipePgPct, top: 130)
        
        recipeVgPct = TextField()
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.font = RobotoFont.regularWithSize(14)
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeVgPct)
        MaterialLayout.size(recipeInfo, child: recipeVgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeVgPct, left: 100)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeVgPct, top: 130)
        
        recipeSteepDays = TextField()
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.font = RobotoFont.regularWithSize(14)
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeSteepDays)
        MaterialLayout.size(recipeInfo, child: recipeSteepDays, width: 120, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeSteepDays, left: 200)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeSteepDays, top: 130)
    }
    
}
