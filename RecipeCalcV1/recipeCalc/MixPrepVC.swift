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
    var settings: Settings!
    
    var pg: T1!
    var vg: T1!
    var strength: T1!
    var nic: T1!
    var amount: T1!
    
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
        prepareTabBar()
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
    
    func prepareTabBar() {
        
        let tabBar: MixTabBar = MixTabBar()
        
        view.addSubview(tabBar)
        MaterialLayout.height(view, child: tabBar, height: 40)
        MaterialLayout.alignFromBottom(view, child: tabBar, bottom: 0)
        MaterialLayout.alignToParentHorizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Back", forState: .Normal)
        btn2.setTitleColor(colors.textDark, forState: .Normal)
        btn2.addTarget(nil, action: #selector(back), forControlEvents: .TouchUpInside)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Mix It!", forState: .Normal)
        btn1.setTitleColor(colors.textDark, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn2, btn1]
        
    }
    func back() {
        navigationController?.pushViewController(MyRecipeVC(recipe: self.recipe), animated: true)
    }
    func mixIt() {
        self.settings = Settings(
            amount: amount.text!,
            strength: strength.text!,
            pg: pg.text!,
            vg: vg.text!,
            nic: nic.text!
        )
        navigationController?.pushViewController(MixVC(recipe: self.recipe, settings: self.settings), animated: true)
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
        MaterialLayout.alignToParent(view, child: settings, top: 80, left: 0, bottom: 49, right: 0)
        
        pg = T1()
        vg = T1()
        strength = T1()
        nic = T1()
        amount = T1()
        
        amount.text = "30"
        amount.placeholder = "Amount to make (ml)"
        strength.text = "3"
        strength.placeholder = "Target Nicotine (mg)"
        pg.text = recipe.vg
        pg.placeholder = "PG%"
        vg.text = recipe.pg
        vg.placeholder = "VG%"
        nic.text = "100"
        nic.placeholder = "Nic Concentrate Strength"
        
        settings.addSubview(amount)
        settings.addSubview(strength)
        settings.addSubview(pg)
        settings.addSubview(vg)
        settings.addSubview(nic)
        
        let children = [amount, strength, pg, vg, nic]
        
        var start: CGFloat = 15
        let spacing: CGFloat = 75
        for child in children {
            MaterialLayout.alignFromTop(settings, child: child, top: start)
            MaterialLayout.alignToParentHorizontally(settings, child: child, left: 30, right: 30)
            start += spacing
        }
    }
}
