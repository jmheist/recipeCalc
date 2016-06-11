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
        navigationItem.title = "Create"
        
        saveBtn = B2()
        saveBtn.setTitle("Add Flavors", forState: .Normal)
        saveBtn.addTarget(self, action: #selector(sendRecipe), forControlEvents: .TouchUpInside)
        
        cancelBtn = B2()
        cancelBtn.setTitle("Cancel", forState: .Normal)
        cancelBtn.addTarget(self, action: #selector(cancelRecipe), forControlEvents: .TouchUpInside)
        
        navigationItem.leftControls = [cancelBtn]
        navigationItem.rightControls = [saveBtn]
        
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        
        MaterialLayout.height(view, child: recipeInfo, height: 220)
        MaterialLayout.alignFromTop(view, child: recipeInfo, top: 0)
        MaterialLayout.alignToParentHorizontally(view, child: recipeInfo, left: 14, right: 14)
        
        // recipe info fields
        
        recipeName = T1()
        recipeName.placeholder = "Recipe Name"
        recipeName.clearButtonMode = .WhileEditing
        recipeName.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeName.errorCheck = true
        recipeName.errorCheckFor = "text"
        recipeName.textLength = 3
        recipeInfo.addSubview(recipeName)
        MaterialLayout.height(recipeInfo, child: recipeName, height: 28)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 25)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName, left: 10, right: 10)
        
        recipeDesc = T2()
        recipeDesc.placeholder = "Recipe Description"
        recipeDesc.clearButtonMode = .WhileEditing
        recipeDesc.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeDesc.errorCheck = true
        recipeDesc.errorCheckFor = "text"
        recipeDesc.textLength = 3
        recipeInfo.addSubview(recipeDesc)
        MaterialLayout.height(recipeInfo, child: recipeDesc, height: 20)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 85)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc, left: 10, right: 10)
        
        recipePgPct = T2()
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.clearButtonMode = .WhileEditing
        recipePgPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipePgPct.errorCheck = true
        recipePgPct.errorCheckFor = "number"
        recipePgPct.numberMax = 100
        recipePgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeInfo.addSubview(recipePgPct)
        MaterialLayout.size(recipeInfo, child: recipePgPct, width: 150, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipePgPct, left: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipePgPct, top: 130)
        
        recipeVgPct = T2()
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeVgPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeVgPct.errorCheck = true
        recipeVgPct.errorCheckFor = "number"
        recipeVgPct.numberMax = 100
        recipeVgPct.addTarget(self, action: #selector(self.updatePgVg(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeInfo.addSubview(recipeVgPct)
        MaterialLayout.size(recipeInfo, child: recipeVgPct, width: 150, height: 18)
        MaterialLayout.alignFromRight(recipeInfo, child: recipeVgPct, right: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeVgPct, top: 130)
        
        recipeNicStrength = T2()
        recipeNicStrength.placeholder = "Nic Strength (mg)"
        recipeNicStrength.clearButtonMode = .WhileEditing
        recipeNicStrength.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeNicStrength.errorCheck = true
        recipeNicStrength.errorCheckFor = "number"
        recipeNicStrength.numberMax = 200
        recipeInfo.addSubview(recipeNicStrength)
        MaterialLayout.size(recipeInfo, child: recipeNicStrength, width: 150, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeNicStrength, left: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeNicStrength, top: 170)
        
        recipeSteepDays = T2()
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeSteepDays.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeSteepDays.errorCheck = true
        recipeSteepDays.errorCheckFor = "number"
        recipeSteepDays.numberMax = 60
        recipeInfo.addSubview(recipeSteepDays)
        MaterialLayout.size(recipeInfo, child: recipeSteepDays, width: 150, height: 18)
        MaterialLayout.alignFromRight(recipeInfo, child: recipeSteepDays, right: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeSteepDays, top: 170)

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
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func sendRecipe() {
        
        let author = AppState.sharedInstance.displayName
        let authorId = AppState.sharedInstance.uid
        
        let fields = [recipeName, recipeDesc, recipePgPct, recipeVgPct, recipeNicStrength, recipeSteepDays]
        
        for field in fields {
            errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            let recipe = Recipe(
                author: author!,
                authorId: authorId!,
                name: recipeName.text!,
                desc: recipeDesc.text!,
                pg: recipePgPct.text!,
                vg: recipeVgPct.text!,
                strength: recipeNicStrength.text!,
                steepDays:recipeSteepDays.text!
            )
            
            view.endEditing(true)
            self.view.resignFirstResponder()
            
            navigationController!.pushViewController(AddFlavorsVC(recipe: recipe), animated: true)
        
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

