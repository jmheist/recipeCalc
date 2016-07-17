//
//  NewUserInfoVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 7/15/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class NewUserInfoVC: UIViewController, UITextFieldDelegate, TextDelegate, TextViewDelegate {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let errorMgr: ErrorManager = ErrorManager()
    
    var infoView: MaterialView!
    var doneButton: B1!
    
    var userNameField: T1!
    var bioField: TView!
    var locationField: T1!
    var bioFieldErrorLabel: L3!
    
    let text: Text = Text()
    var didSendComment: Bool = false
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareSpinner()
        prepareTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    func prepareTextFields() {
        
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        text.delegate = self
        text.textStorage.addLayoutManager(layoutManager)
        
        infoView = MaterialView()
        view.layout(infoView).top(20).bottom(20).left(20).right(20)
        
        userNameField = T1()
        userNameField.placeholder = "Username"
        userNameField.errorCheck = true
        userNameField.errorCheckFor = "username"
        userNameField.textMinLength = 3
        userNameField.textMaxLength = 30
        
        infoView.layout(userNameField).top(50)
        
        let bioFieldLabel: L2 = L2()
        bioFieldLabel.text = "bio"
        
        infoView.layout(bioFieldLabel).top(90)
        
        bioField = TView(textContainer: textContainer)
        bioField.maxLength = 90
        bioField.errorCheck = true
        bioField.placeholderText = "A little about you."
        
        infoView.layout(bioField).top(110).height(80)
        
        bioFieldErrorLabel = L3()
        bioFieldErrorLabel.textColor = colors.error
        bioFieldErrorLabel.text = ""
        
        infoView.layout(bioFieldErrorLabel).top(200)
        
        locationField = T1()
        locationField.placeholder = "Location"
        locationField.errorCheck = true
        locationField.errorCheckFor = "text"
        locationField.textMaxLength = 40
        
        infoView.layout(locationField).top(230)
        
        doneButton = B1()
        doneButton.setTitle("Submit", forState: .Normal)
        doneButton.addTarget(self, action: #selector(didTapDone), forControlEvents: .TouchUpInside)
        
        infoView.layout(doneButton).centerHorizontally().top(290).width(100)
        
        let children = [userNameField, bioFieldLabel, bioField, bioFieldErrorLabel, locationField]
        
        for child in children {
            infoView.layout(child).left(14).right(14)
        }
        
        
    }
    
    func didTapDone() {
        
        showSpinner()
        
        let fields = [userNameField, locationField]
        
//        errorMgr.errorCheck(textview: bioField, errorLabel: bioFieldErrorLabel)
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        setTimeout(1) { 
            if !self.errorMgr.hasErrors() {
                UserMgr.sendNewUserInfo(AppState.sharedInstance.signedInUser.uid!, username: self.userNameField.text!, bio: self.bioField.text, location: self.locationField.text!, completionHandler: {
                    
                    UserMgr.loadApp({ (vc) in
                        self.presentViewController(vc, animated: true, completion: nil)
                    })
                    
                })
                
            } else {
                self.hideSpinner()
            }
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
    
    
    /**
     When changes in the textView text are made, this delegation method
     is executed with the added text string and range.
     */
    func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
        if !didSendComment {
            textStorage.removeAttribute(NSFontAttributeName, range: range)
            textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
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
