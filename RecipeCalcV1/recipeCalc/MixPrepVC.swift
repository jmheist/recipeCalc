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
    var settings: MixSettings!
    
    var pgMin = 0.0
    
    let errorMgr: ErrorManager = ErrorManager()
    
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
        prepareTabBar()
        prepareRecipeInfo()
        prepareMixSettings()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
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
        Layout.height(view, child: tabBar, height: 40)
        Layout.bottom(view, child: tabBar, bottom: 0)
        Layout.horizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Back", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(nil, action: #selector(back), forControlEvents: .TouchUpInside)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Mix It!", forState: .Normal)
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn2, btn1]
        
    }
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    func mixIt() {
        func finish() {
            let children = [amount, strength, pg, vg, nic]
            
            for child in children {
                errorMgr.errorCheck(child)
            }
                    
            if !errorMgr.hasErrors() {
                self.settings = MixSettings(
                    amount: Float(amount.text!)!,
                    strength: Float(strength.text!)!,
                    pg: Float(pg.text!)!,
                    vg: Float(vg.text!)!,
                    nic: Float(nic.text!)!
                )
                mixMgr.saveMixSettingsToFB(AppState.sharedInstance.signedInUser.uid!, recipe: recipe.key, settings: self.settings)
                navigationController?.pushViewController(MixVC(recipe: self.recipe, settings: self.settings), animated: true)
            }
        }
        
        calcPGTotals { (totalPg) in
            if totalPg > Double(self.pg.text!) {
                alertMgr.alertWithOptions("PG% is too low", message: "We can fix that, just press Continue, or press Edit to fix yourself.\n\nThe PG% minimum for this recipe is \(totalPg)", cancelBtn: "Edit", conFirmBtn: "Continue", completionHanlder: { (confirmed) in
                    if confirmed {
                        self.pg.text = String(totalPg)
                        self.vg.text = String(100 - totalPg)
                        finish()
                    }
                })
            } else {
                finish()
            }
        }
    }
    
    func prepareRecipeInfo() {
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        Layout.top(view, child: recipeInfo, top: 0)
        Layout.height(view, child: recipeInfo, height: 50)
        Layout.horizontally(view, child: recipeInfo, left: 10, right: 10)
        
        let recipeName: L1 = L1()
        let recipeDesc: L2 = L2()
        
        recipeName.text = recipe.name
        recipeDesc.text = recipe.desc
        recipeName.textAlignment = .Center
        recipeDesc.textAlignment = .Center
        
        recipeInfo.addSubview(recipeName)
        recipeInfo.addSubview(recipeDesc)
        
        
        Layout.top(recipeInfo, child: recipeName, top: 15)
        Layout.top(recipeInfo, child: recipeDesc, top: 45)
        Layout.horizontally(recipeInfo, child: recipeName)
        Layout.horizontally(recipeInfo, child: recipeDesc)
        
        calcPGTotals { (pgTotal) in
            self.pgMin = pgTotal
            self.pg.numberMin = pgTotal
        }
        
    }
    
    func prepareMixSettings() {
        
        let settings: MaterialView = MaterialView()
        view.addSubview(settings)
        Layout.edges(view, child: settings, top: 80, left: 0, bottom: 49, right: 0)
        
        pg = T1()
        pg.keyboardType = UIKeyboardType.NumbersAndPunctuation
        pg.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        pg.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        pg.errorCheck = true
        pg.errorCheckFor = "number"
        pg.numberMax = 100
        pg.numberMin = pgMin
        
        vg = T1()
        vg.keyboardType = UIKeyboardType.NumbersAndPunctuation
        vg.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        vg.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        vg.errorCheck = true
        vg.errorCheckFor = "number"
        vg.numberMax = 100
        
        strength = T1()
        strength.keyboardType = UIKeyboardType.NumbersAndPunctuation
        strength.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        strength.errorCheck = true
        strength.errorCheckFor = "number"
        strength.numberMax = 40
        
        nic = T1()
        nic.keyboardType = UIKeyboardType.NumbersAndPunctuation
        nic.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        nic.errorCheck = true
        nic.errorCheckFor = "number"
        nic.numberMax = 200
        
        amount = T1()
        amount.keyboardType = UIKeyboardType.NumbersAndPunctuation
        amount.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        amount.errorCheck = true
        amount.errorCheckFor = "number"
        amount.numberMax = 10000
        
        amount.text = "30"
        amount.placeholder = "Amount to make (ml)"
        strength.text = recipe.strength
        strength.placeholder = "Target Nicotine (mg)"
        pg.text = recipe.pg
        pg.placeholder = "PG%"
        vg.text = recipe.vg
        vg.placeholder = "VG%"
        nic.text = "100"
        nic.placeholder = "Nic Concentrate Strength"
        
        mixMgr.getUserRecipeSettings(AppState.sharedInstance.signedInUser.uid!, recipe: recipe.key) { (mixSettings) in
            self.amount.text = String(mixSettings.amount)
            self.strength.text = String(mixSettings.strength)
            self.pg.text = String(mixSettings.pg)
            self.vg.text = String(mixSettings.vg)
            self.nic.text = String(mixSettings.nic)
            print("Loaded remote settings")
        }
        
        let children = [amount, strength, pg, vg, nic]
        
        var start: CGFloat = 15
        let spacing: CGFloat = 75
        for child in children {
            settings.addSubview(child)
            Layout.top(settings, child: child, top: start)
            Layout.horizontally(settings, child: child, left: 30, right: 30)
            start += spacing
        }
    }
    
    func calcPGTotals(completionHandler:(Double)->()) {
        let flavorMgr: FlavorManager = FlavorManager()
        flavorMgr.getFlavorsForRecipe(self.recipe.key) { (flavors) in
            var pgTotalPct = 0.0
            for flavor in flavors {
                if flavor.base == "PG" {
                    pgTotalPct = pgTotalPct + Double(flavor.pct)!
                }
            }
            print("PG TOTAL %: \(pgTotalPct)")
            completionHandler(pgTotalPct)
        }
    }
    
    func updatePgVg(sender: myTextField) {
        if Float(sender.text!) != nil {
            if Float(sender.text!) <= Float(100) && Float(sender.text!) >= Float(0) {
                if Float(sender.text!) == Float(pg.text!) {
                    vg.text = String(Float(100) - Float(sender.text!)!)
                } else if Float(sender.text!) == Float(vg.text!) {
                    pg.text = String(Float(100) - Float(sender.text!)!)
                }
            }
        }
    }
    
    func liveCheck(field: myTextField) {
        errorMgr.errorCheck(field)
    }
}
