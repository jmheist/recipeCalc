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
        
        let stepDesc: StepDescLabel = StepDescLabel()
        stepDesc.text = "Setup your account details."
        infoView.layout(stepDesc).top(10)
        
        userNameField = T1()
        userNameField.placeholder = "Username"
        userNameField.errorCheck = true
        userNameField.errorCheckFor = "username"
        userNameField.textMinLength = 3
        userNameField.textMaxLength = 30
        userNameField.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        infoView.layout(userNameField).top(50)
        
        bioField = TView(textContainer: textContainer)
        bioField.maxLength = 80
        bioField.errorCheck = true
        bioField.placeholderLabel?.text = "Bio: A little about you."
        
        infoView.layout(bioField).top(160).height(60)
        
        locationField = T1()
        locationField.placeholder = "Location"
        locationField.errorCheck = true
        locationField.errorCheckFor = "text"
        locationField.textMaxLength = 40
        locationField.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        
        infoView.layout(locationField).top(245)
        
        doneButton = B1()
        doneButton.setTitle("Submit", forState: .Normal)
        doneButton.addTarget(self, action: #selector(didTapDone), forControlEvents: .TouchUpInside)
        
        infoView.layout(doneButton).centerHorizontally().top(320).width(100)
        
        let children = [stepDesc, userNameField, bioField, locationField]
        
        for child in children {
            infoView.layout(child).left(14).right(14)
        }
        
    }
    
    func didTapDone() {
        
        showSpinner()
        
        let fields = [userNameField, locationField]
        
        errorMgr.errorCheck(textview: bioField)
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
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
