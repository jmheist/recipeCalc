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

class CreateRecipeViewController: UIViewController, UITextFieldDelegate  {
    
    let errorMgr: ErrorManager = ErrorManager()
    var edit: Bool = false
    
    // text fields
    private var recipeName: T1!
    private var recipeDesc: TView!
    
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
        if AppState.sharedInstance.recipe != nil {
            self.edit = true
            recipeName.text = AppState.sharedInstance.recipe.name
            recipeDesc.text = AppState.sharedInstance.recipe.desc
        } else {
            AppState.sharedInstance.recipe = Recipe()
            clearForm()
        }
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create  "
        tabBarItem.image = UIImage(named: "create_new")
    }
    
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        if edit {
            navigationItem.title = "Edit"
            navigationItem.backButton?.addTarget(self, action: #selector(cancelRecipe), forControlEvents: .TouchUpInside)
            navigationItem.backButton?.titleLabel?.text = "Cancel"
        } else {
            navigationItem.title = "Create"
            let clearButton = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(cancelRecipe))
            navigationItem.leftBarButtonItems = [clearButton]
        }
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(sendRecipe))
        navigationItem.rightBarButtonItems = [nextButton]
                
    }
    
    func prepareTextFields() {
        
        
        let recipeInfo: MaterialView = MaterialView()
        view.layout(recipeInfo).top(0).left(14).right(14).bottom(0)
        
        let stepDesc: StepDescLabel = StepDescLabel()
        stepDesc.text = "Give your recipe a name\nand then add a description."
        
        // recipe info fields
        
        recipeName = T1()
        recipeName.placeholder = "Name"
        recipeName.clearButtonMode = .WhileEditing
        recipeName.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        recipeName.errorCheck = true
        recipeName.errorCheckFor = "text"
        recipeName.textMinLength = 3
        recipeName.textMaxLength = 25
        
        let noteLabel: L3 = L3()
        noteLabel.text = "Description"
        noteLabel.textAlignment = .Left
        
        recipeDesc = TView()
        
        recipeInfo.layout(recipeDesc).height(80)
        
        let children = [stepDesc, recipeName, noteLabel, recipeDesc]
        
        var dist = 30
        var spacing = 75
        for child in children {
            recipeInfo.layout(child).top(CGFloat(dist)).horizontally(left: 14, right: 14)
            if dist > 170 {
                spacing = 25
            }
            dist += spacing
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
        
        let author = AppState.sharedInstance.signedInUser.username
        let authorId = AppState.sharedInstance.signedInUser.uid
        
        let fields = [recipeName]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            
            if edit {
                AppState.sharedInstance.recipe.name = recipeName.text!
                AppState.sharedInstance.recipe.desc = recipeDesc.text!
            } else {
                AppState.sharedInstance.recipe = Recipe()
                AppState.sharedInstance.recipe.author = author!
                AppState.sharedInstance.recipe.authorId = authorId!
                AppState.sharedInstance.recipe.name = recipeName.text!
                AppState.sharedInstance.recipe.desc = recipeDesc.text!
            }
            
            view.endEditing(true)
            self.view.resignFirstResponder()
            
            navigationController!.pushViewController(CreateRecipeSettingsVC(edit: self.edit), animated: true)
        
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
        AppState.sharedInstance.recipe = nil
        recipeName.text = ""
        recipeDesc.text = ""
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

