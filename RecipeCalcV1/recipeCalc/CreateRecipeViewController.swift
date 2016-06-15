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

class CreateRecipeViewController: UIViewController, UITextFieldDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    var recipe: Recipe!
    var edit: Bool = Bool()
    
    // text fields
    private var recipeName: T1!
    private var recipeDesc: T2!
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
        prepareTabBarItem()
    }
    
    convenience init(recipe: Recipe, edit: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
        self.edit = edit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        prepareView()
        prepareNavigationItem()
        prepareTextFields()
    }
    
    func configureDatabase() {
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
        if edit {
            navigationItem.title = "Edit"
        } else {
            navigationItem.title = "Create"
        }
        saveBtn = B2()
        saveBtn.setTitle("Add Flavors", forState: .Normal)
        saveBtn.addTarget(self, action: #selector(sendRecipe), forControlEvents: .TouchUpInside)
        
        navigationItem.rightControls = [saveBtn]
        
        if self.recipe != nil && self.recipe.key == "" {
            cancelBtn = B2()
            cancelBtn.setTitle("Cancel", forState: .Normal)
            cancelBtn.addTarget(self, action: #selector(cancelRecipe), forControlEvents: .TouchUpInside)
            navigationItem.leftControls = [cancelBtn]
        }
        
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        
        Layout.edges(view, child: recipeInfo, top: 0, left: 0, bottom: 49, right: 0)
        
        // recipe info fields
        
        recipeName = T1()
        recipeName.placeholder = "Recipe Name"
        recipeName.clearButtonMode = .WhileEditing
        recipeName.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeName.errorCheck = true
        recipeName.errorCheckFor = "text"
        recipeName.textLength = 3
        
        recipeDesc = T2()
        recipeDesc.placeholder = "Recipe Description"
        recipeDesc.clearButtonMode = .WhileEditing
        recipeDesc.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeDesc.errorCheck = true
        recipeDesc.errorCheckFor = "text"
        recipeDesc.textLength = 3
        
        recipePgPct = T2()
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.clearButtonMode = .WhileEditing
        recipePgPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipePgPct.errorCheck = true
        recipePgPct.errorCheckFor = "number"
        recipePgPct.numberMax = 100
        recipePgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        recipeVgPct = T2()
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeVgPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeVgPct.errorCheck = true
        recipeVgPct.errorCheckFor = "number"
        recipeVgPct.numberMax = 100
        recipeVgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        recipeNicStrength = T2()
        recipeNicStrength.placeholder = "Nic Strength (mg)"
        recipeNicStrength.clearButtonMode = .WhileEditing
        recipeNicStrength.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeNicStrength.errorCheck = true
        recipeNicStrength.errorCheckFor = "number"
        recipeNicStrength.numberMax = 200
        
        recipeSteepDays = T2()
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeSteepDays.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeSteepDays.errorCheck = true
        recipeSteepDays.errorCheckFor = "number"
        recipeSteepDays.numberMax = 60
        
        let children = [recipeName, recipeDesc, recipePgPct, recipeVgPct, recipeNicStrength, recipeSteepDays]
        
        var start = CGFloat(30)
        let spacing = CGFloat(75)
        for child in children {
            recipeInfo.addSubview(child)
            Layout.top(recipeInfo, child: child, top: start)
            Layout.horizontally(recipeInfo, child: child, left: 30, right: 30)
            start += spacing
        }
        
        if edit {
            recipeName.text = recipe.name
            recipeDesc.text = recipe.desc
            recipePgPct.text = recipe.pg
            recipeVgPct.text = recipe.vg
            recipeNicStrength.text = recipe.strength
            recipeSteepDays.text = recipe.steepDays
        }
        
    }
    
    func updatePgVg(sender: myTextField) {
        if Float(sender.text!) != nil {
            if Float(sender.text!) <= Float(100) && Float(sender.text!) >= Float(0) {
                print(Float(sender.text!), Float(recipeVgPct.text!), Float(recipePgPct.text!))
                print(Float(sender.text!) == Float(recipeVgPct.text!))
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
        
        let author = AppState.sharedInstance.displayName
        let authorId = AppState.sharedInstance.uid
        
        let fields = [recipeName, recipeDesc, recipePgPct, recipeVgPct, recipeNicStrength, recipeSteepDays]
        
        for field in fields {
            errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            
            if edit {
                recipe.name = recipeName.text!
                recipe.desc = recipeDesc.text!
                recipe.pg = recipePgPct.text!
                recipe.vg = recipeVgPct.text!
                recipe.strength = recipeNicStrength.text!
                recipe.steepDays = recipeSteepDays.text!
            } else {
                recipe = Recipe(
                    author: author!,
                    authorId: authorId!,
                    name: recipeName.text!,
                    desc: recipeDesc.text!,
                    pg: recipePgPct.text!,
                    vg: recipeVgPct.text!,
                    strength: recipeNicStrength.text!,
                    steepDays: recipeSteepDays.text!
                )
            }
            
            view.endEditing(true)
            self.view.resignFirstResponder()
            
            navigationController!.pushViewController(AddFlavorsVC(recipe: recipe, edit: self.edit), animated: true)
        
        } else { // there was errors
            
            print("errors: \(errorMgr.hasErrors())")
            
        }
    }
    
    func errorCheck(field: myTextField) {
        if field.errorCheck {
            print("Checking field: '\(field.placeholder)' for errors")
            let res = errorMgr.checkForErrors(
                field.text!, // data:
                placeholder: field.placeholder!,
                checkFor: Check(
                    type: field.errorCheckFor,
                    length: field.textLength,
                    numberMax: field.numberMax
                )
            )
            if res.error {
                print("found an error with \(field)")
                field.detail = res.errorMessage
                field.revealError = true
                field.detailColor = colors.errorRed
                field.dividerColor = colors.errorRed
            } else {
                field.revealError = false
                field.detailColor = colors.dark
                field.dividerColor = colors.dark
            }
        }
    }
    
    func clearForm() {
        view.endEditing(true)
        self.view.resignFirstResponder()
        recipeName.text = ""
        recipeDesc.text = ""
        recipePgPct.text = ""
        recipeVgPct.text = ""
        recipeSteepDays.text = ""
    }
    
}

