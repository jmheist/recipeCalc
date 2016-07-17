//
//  NewUserInfoVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 7/15/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class NewUserInfoVC: UIViewController {
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let errorMgr: ErrorManager = ErrorManager()
    
    var infoView: MaterialView!
    var doneButton: B1!
    
    var userNameField: T1!
    var bioField: TView!
    var locationField: T1!
    var bioFieldErrorLabel: L3!
    
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
        prepareButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareView() {
    }
    
    func prepareTextFields() {
        
        infoView = MaterialView()
        view.layout(infoView).edges()
        
        userNameField = T1()
        userNameField.placeholder = "Username"
        userNameField.errorCheck = true
        userNameField.errorCheckFor = "username"
        userNameField.textLength = 30
        
        infoView.layout(userNameField).top(50).left(8).right(8)
        
        let bioFieldLabel: L2 = L2()
        bioFieldLabel.text = "bio"
        
        infoView.layout(bioFieldLabel).top(90).left(8).right(8)
        
        bioField = TView()
        bioField.maxLength = 90
        bioField.errorCheck = true
        bioField.placeholderText = "A little about you."
        
        infoView.layout(bioField).top(110).left(8).right(8).height(80)
        
        bioFieldErrorLabel = L3()
        bioFieldErrorLabel.textColor = colors.error
        bioFieldErrorLabel.text = ""
        
        infoView.layout(bioFieldErrorLabel).top(200).left(8).right(8)
        
        locationField = T1()
        locationField.placeholder = "Location"
        locationField.errorCheck = true
        locationField.errorCheckFor = "text"
        locationField.textLength = 40
        
        infoView.layout(locationField).top(230).left(8).right(8)
        
        
    }
    
    func prepareButton() {
        
        doneButton = B1()
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.addTarget(self, action: #selector(didTapDone), forControlEvents: .TouchUpInside)
        
        view.layout(doneButton).centerHorizontally().bottom(30).width(100)
        
    }
    
    func didTapDone() {
        
        showSpinner()
        
        let fields = [userNameField, locationField]
        
        errorMgr.errorCheck(textview: bioField, errorLabel: bioFieldErrorLabel)
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            
            UserMgr.sendNewUserInfo(AppState.sharedInstance.signedInUser.uid!, username: self.userNameField.text!, bio: self.bioField.text, location: self.locationField.text!, completionHandler: {
                
                UserMgr.loadApp({ (vc) in
                    self.presentViewController(vc, animated: true, completion: nil)
                })
                
            })
            
        } else {
            hideSpinner()
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
    
}
