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

class CreateRecipeViewController: UIViewController, UITextFieldDelegate, TextDelegate  {
    
    let errorMgr: ErrorManager = ErrorManager()
    var edit: Bool = false
    let text: Text = Text()
    var didSendComment: Bool = false
    
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
        
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        text.delegate = self
        text.textStorage.addLayoutManager(layoutManager)

        
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
        recipeName.textMaxLength = 30
        
        recipeDesc = TView(textContainer: textContainer)
        recipeDesc.maxLength = 70
        recipeDesc.errorCheck = true
        recipeDesc.placeholderLabel!.text = "Description"
        
        recipeInfo.layout(recipeDesc).height(60)
        
        let children = [stepDesc, recipeName, recipeDesc]
        
        var dist = 30
        let spacing = 85
        for child in children {
            recipeInfo.layout(child).top(CGFloat(dist)).horizontally(left: 14, right: 14)
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
        
        errorMgr.errorCheck(textview: self.recipeDesc)
        
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
            print(recipeDesc.titleLabel?.text)
            print("errors: \(errorMgr.hasErrors())")
            
        }
    }
    
    func liveCheck(field: myTextField) {
        errorMgr.errorCheck(field)
    }
    
    func liveCheckTV(field: TView) {
        errorMgr.errorCheck(textview: field)
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
    
    /**
     When changes in the textView text are made, this delegation method
     is executed with the added text string and range.
     */
    func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
        if !didSendComment {
            textStorage.removeAttribute(NSFontAttributeName, range: range)
            textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
            liveCheckTV(recipeDesc)
        } else {
            didSendComment = false
        }
    }
    
    /**
     When a match is detected within the textView text, this delegation
     method is executed with the added text string and range.
     */
    func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
        textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: result!.range)
    }
}

