//
//  CreateRecipeViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class CreateRecipeSettingsVC: UIViewController, UITextFieldDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    var edit: Bool = false
    var scrollView: UIScrollView!
    
    // text fields
    private var recipePgPct: T2!
    private var recipeVgPct: T2!
    private var recipeNicStrength: T2!
    private var recipeSteepDays: T2!
    
    // nav save button
    private var saveBtn: B2!
    private var cancelBtn: B2!
    
    // db vars
    private var _refHandle: FIRDatabaseHandle!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(edit: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.edit = edit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        prepareView()
        prepareTextFields()
        prepareKeyboardHandler()
    }
    
    override func viewWillAppear(animated: Bool) {
        prepareData()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
    }
    
    func configureDatabase() {
    }
    
    func prepareData() {
        recipePgPct.text = AppState.sharedInstance.recipe.pg
        recipeVgPct.text = AppState.sharedInstance.recipe.vg
        recipeNicStrength.text = AppState.sharedInstance.recipe.strength
        recipeSteepDays.text = AppState.sharedInstance.recipe.steepDays
    }

    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create"
        tabBarItem.image = MaterialIcon.add
    }
    
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        
        navigationItem.title = "Recipe Settings"
        navigationItem.backButton?.addTarget(self, action: #selector(cancelRecipe), forControlEvents: .TouchUpInside)
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(sendRecipe))
        navigationItem.rightBarButtonItems = [nextButton]
        
    }
    
    func prepareTextFields() {
        
        
        let recipeInfo: MaterialView = MaterialView()
        view.layout(recipeInfo).top(0).left(14).right(14).bottom(0)
        
        // recipe info fields
        
        recipePgPct = T2()
        recipePgPct.keyboardType = UIKeyboardType.NumbersAndPunctuation
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.clearButtonMode = .WhileEditing
        recipePgPct.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipePgPct.errorCheck = true
        recipePgPct.errorCheckFor = "number"
        recipePgPct.numberMax = 100
        recipePgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        recipeVgPct = T2()
        recipeVgPct.keyboardType = UIKeyboardType.NumbersAndPunctuation
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeVgPct.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeVgPct.errorCheck = true
        recipeVgPct.errorCheckFor = "number"
        recipeVgPct.numberMax = 100
        recipeVgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        recipeNicStrength = T2()
        recipeNicStrength.keyboardType = UIKeyboardType.NumbersAndPunctuation
        recipeNicStrength.placeholder = "Nic Strength (mg)"
        recipeNicStrength.clearButtonMode = .WhileEditing
        recipeNicStrength.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeNicStrength.errorCheck = true
        recipeNicStrength.errorCheckFor = "number"
        recipeNicStrength.numberMax = 200
        
        recipeSteepDays = T2()
        recipeSteepDays.keyboardType = UIKeyboardType.NumbersAndPunctuation
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeSteepDays.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeSteepDays.errorCheck = true
        recipeSteepDays.errorCheckFor = "number"
        recipeSteepDays.numberMax = 60
        
        let children = [recipePgPct, recipeVgPct, recipeNicStrength, recipeSteepDays]
        
        var dist = 30
        let spacing = 75
        for child in children {
            recipeInfo.addSubview(child)
            recipeInfo.layout(child).top(CGFloat(dist)).horizontally(left: 14, right: 14)
            dist += spacing
        }
        
    }
    
    func updatePgVg(sender: myTextField) {
        if Float(sender.text!) != nil {
            if Float(sender.text!) <= Float(100) && Float(sender.text!) >= Float(0) {
                if Float(sender.text!) == Float(recipePgPct.text!) {
                    recipeVgPct.text = String(Float(100) - Float(sender.text!)!)
                } else if Float(sender.text!) == Float(recipeVgPct.text!) {
                    recipePgPct.text = String(Float(100) - Float(sender.text!)!)
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        self.view.resignFirstResponder()
    }
    
    func cancelRecipe() {
        clearForm()
    }
    
    func sendRecipe() {
        
        let fields = [recipePgPct, recipeVgPct, recipeNicStrength, recipeSteepDays]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            
            if edit {
                AppState.sharedInstance.recipe.pg = recipePgPct.text!
                AppState.sharedInstance.recipe.vg = recipeVgPct.text!
                AppState.sharedInstance.recipe.strength = recipeNicStrength.text!
                AppState.sharedInstance.recipe.steepDays = recipeSteepDays.text!
            } else {
                AppState.sharedInstance.recipe.pg = recipePgPct.text!
                AppState.sharedInstance.recipe.vg = recipeVgPct.text!
                AppState.sharedInstance.recipe.strength = recipeNicStrength.text!
                AppState.sharedInstance.recipe.steepDays = recipeSteepDays.text!
            }
            
            view.endEditing(true)
            self.view.resignFirstResponder()
            
            navigationController!.pushViewController(AddFlavorsVC(edit: self.edit), animated: true)
            
        } else { // there was errors
            
            print("errors: \(errorMgr.hasErrors())")
            
        }
    }
    
    func liveCheck(field: myTextField) {
        errorMgr.errorCheck(field)
    }
    
    func clearForm() {
        view.endEditing(true)
        self.view.resignFirstResponder()
        recipePgPct.text = ""
        recipeVgPct.text = ""
        recipeNicStrength.text = ""
        recipeSteepDays.text = ""
    }
    
    func prepareKeyboardHandler() {
        // Call this method somewhere in your view controller setup code.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // Called when the UIKeyboardDidShowNotification is sent.
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        hideStatusBar(-20)
    }
    // Called when the UIKeyboardWillHideNotification is sent
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        showStatusBar()
    }
    
    func hideStatusBar(yOffset:CGFloat) { // -20.0 for example
        let statusBarWindow = UIApplication.sharedApplication().valueForKey("statusBarWindow") as! UIWindow
        statusBarWindow.frame = CGRectMake(0, yOffset, statusBarWindow.frame.size.width, statusBarWindow.frame.size.height)
    }
    
    func showStatusBar() {
        let statusBarWindow = UIApplication.sharedApplication().valueForKey("statusBarWindow") as! UIWindow
        statusBarWindow.frame = CGRectMake(0, 0, statusBarWindow.frame.size.width, statusBarWindow.frame.size.height)
    }
    
}

