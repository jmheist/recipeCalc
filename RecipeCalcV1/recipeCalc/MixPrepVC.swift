//
//  MixPrepVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/8/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class MixPrepVC: UIViewController {
    
    var recipe: Recipe!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavigationItem()
        prepareRecipeInfo()
        prepareMixSettings()
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = ""
    }
    
    func prepareRecipeInfo() {
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        MaterialLayout.alignFromTop(view, child: recipeInfo, top: 0)
        MaterialLayout.height(view, child: recipeInfo, height: 50)
        MaterialLayout.alignToParentHorizontally(view, child: recipeInfo, left: 10, right: 10)
        
        let recipeName: L1 = L1()
        let recipeDesc: L2 = L2()
        
        recipeName.text = recipe.name
        recipeDesc.text = recipe.desc
        recipeName.textAlignment = .Center
        recipeDesc.textAlignment = .Center
        
        recipeInfo.addSubview(recipeName)
        recipeInfo.addSubview(recipeDesc)
        
        
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 15)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 45)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc)
        
    }
    
    func prepareMixSettings() {
        
        let settings: MaterialView = MaterialView()
        view.addSubview(settings)
        MaterialLayout.alignToParent(view, child: settings, top: 60, left: 0, bottom: 49, right: 0)
        
        let pg: T2 = T2()
        let vg: T2 = T2()
        let strength: T2 = T2()
        let nic: T2 = T2()
        let amount: T2 = T2()
        
        amount.text = "30"
        amount.placeholder = "Amount to make (mg)"
        strength.text = "3"
        strength.placeholder = "Strength of nic in recipe"
        pg.text = recipe.vg
        pg.placeholder = "PG%"
        vg.text = recipe.pg
        vg.placeholder = "VG%"
        nic.text = "100"
        nic.placeholder = "Nic Stregth"
        
        settings.addSubview(amount)
        settings.addSubview(strength)
        settings.addSubview(pg)
        settings.addSubview(vg)
        settings.addSubview(nic)
        
        let children = [amount, strength, pg, vg, nic]
        
        MaterialLayout.alignFromTop(settings, child: amount, top: 5)
        MaterialLayout.alignFromTop(settings, child: strength, top: 30)
        MaterialLayout.alignFromTop(settings, child: pg, top: 55)
        MaterialLayout.alignFromTop(settings, child: vg, top: 80)
        MaterialLayout.alignFromTop(settings, child: nic, top: 95)
        
        MaterialLayout.alignToParentHorizontally(settings, children: children, left: 15, right: 15)
        
    }
}
