//
//  SettingsViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class UpdateProfileVC: UIViewController, TextDelegate {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let errorMgr: ErrorManager = ErrorManager()
    
    var infoView: MaterialView!
    var doneButton: B1!
    
    var userNameField: T1!
    var bioField: TView!
    var locationField: T1!
    
    let text: Text = Text()
    var didSendComment: Bool = false
    
    private var location: T1!
    private var userBio: TextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTextFields()
        prepareKeyboardHandler()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Update Your Profile"
    }
    
    func prepareTextFields() {
        
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        text.delegate = self
        text.textStorage.addLayoutManager(layoutManager)
        
        infoView = MaterialView()
        view.layout(infoView).top(20).bottom(20).left(20).right(20)
        
        bioField = TView(textContainer: textContainer)
        bioField.text = AppState.sharedInstance.signedInUser.bio
        bioField.maxLength = 80
        bioField.errorCheck = true
        bioField.placeholderLabel?.text = "Bio: A little bit about yourself."
        
        infoView.layout(bioField).top(60).height(60)
        
        locationField = T1()
        locationField.text = AppState.sharedInstance.signedInUser.location
        locationField.placeholder = "Location"
        locationField.errorCheck = true
        locationField.errorCheckFor = "text"
        locationField.textMaxLength = 30
        locationField.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        infoView.layout(locationField).top(160)
        
        doneButton = B1()
        doneButton.setTitle("Submit", forState: .Normal)
        doneButton.addTarget(self, action: #selector(didTapDone), forControlEvents: .TouchUpInside)
        
        infoView.layout(doneButton).centerHorizontally().top(240).width(100)
        
        let children = [bioField, locationField]
        
        for child in children {
            infoView.layout(child).left(14).right(14)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
    
    
    func didTapDone() {
        
        showSpinner()
        
        let fields = [locationField]
        
        errorMgr.errorCheck(textview: bioField)
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !self.errorMgr.hasErrors() {
            UserMgr.sendNewUserInfo(AppState.sharedInstance.signedInUser.uid!, bio: self.bioField.text, location: self.locationField.text!, completionHandler: {
                UserMgr.loadApp({ (vc) in
                    self.navigationController?.popViewControllerAnimated(true)
                })
                
            })
            
        } else {
            self.hideSpinner()
        }
    
    }
    
    func prepareSpinner() {
        view.layout(spinner).center()
        spinner.activityIndicatorViewStyle = .WhiteLarge
        spinner.color = colors.medium
        spinner.hidesWhenStopped = true
    }
    
    func showSpinner() {
        // hide everytihng else
        infoView.hidden = true
        doneButton.hidden = true
        
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        
        // show everything again
        infoView.hidden = false
        doneButton.hidden = false
    }
    
    func liveCheck(field: myTextField) {
        errorMgr.errorCheck(field)
    }
    
    func liveCheckTV(field: TView) {
        errorMgr.errorCheck(textview: field)
    }
    
    
    /**
     When changes in the textView text are made, this delegation method
     is executed with the added text string and range.
     */
    func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
        if !didSendComment {
            textStorage.removeAttribute(NSFontAttributeName, range: range)
            textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
            liveCheckTV(bioField)
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
