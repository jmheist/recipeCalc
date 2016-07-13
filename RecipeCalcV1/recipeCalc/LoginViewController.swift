//
//  LoginViewCOntroller.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/17/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class LoginViewController: UIViewController, TextFieldDelegate {

    let errorMgr: ErrorManager = ErrorManager()
    
    private var emailField: T1!,
                passwordField: T1!,
                fbErrorLabel: L3!;
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var loginView: MaterialView!
    var cancelView: MaterialView!
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailLogin()
        prepareCancelLink()
        prepareSpinner()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    //
    // Login Forms
    //
    
    func prepareEmailLogin() {
        
        loginView = MaterialView()
        view.addSubview(loginView)
        view.layout(loginView).top(20).left(20).right(20).bottom(60)
        
        let loginLabel: L1 = L1()
        loginLabel.text = "Login"
        loginLabel.textAlignment = .Center
        
        // EMAIL FIELD //
        
        emailField = T1()
        emailField.placeholder = "Email"
        emailField.errorCheck = true
        emailField.errorCheckFor = "loginField"
        emailField.enableClearIconButton = true
        emailField.delegate = self
        
        // PASSWORD FIELD //
        
        passwordField = T1()
        passwordField.placeholder = "Password"
        passwordField.errorCheck = true
        passwordField.errorCheckFor = "loginField"
        passwordField.enableVisibilityIconButton = true
        
        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = colors.dark
        
        // BUTTONS //
        
        let signInButton: B1 = B1()
        signInButton.addTarget(self, action: #selector(didTapSignIn), forControlEvents: .TouchUpInside)
        signInButton.setTitle("Sign In", forState: .Normal)
        
        let forgotPasswordButton: B1 = B1()
        forgotPasswordButton.addTarget(self, action: #selector(didRequestPasswordReset), forControlEvents: .TouchUpInside)
        forgotPasswordButton.setTitle("Forgot Password", forState: .Normal)
        
        // LAYOUT //
        
        let children = [loginLabel, emailField, passwordField, signInButton, forgotPasswordButton]
        var dist = 10
        let spacing = 65
        for child in children {
            loginView.addSubview(child)
            loginView.layout(child).top(CGFloat(dist)).horizontally(left: 10, right: 10)
            dist += spacing
        }
        
    }
    
    // FUNCTIONS FOR EMAIL REGISTRATION FORM //
    
    /// Executed when the 'return' key is pressed when using the emailField.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.revealError = true
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        (textField as? ErrorTextField)?.revealError = false
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        (textField as? ErrorTextField)?.revealError = false
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        (textField as? ErrorTextField)?.revealError = false
        return true
    }
    
    //
    // Login Functions
    //
    
    func didTapSignIn() {
        let fields = [emailField, passwordField]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
            showSpinner()
            // Sign In with credentials.
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    alertMgr.alert("Sign in error", message: error.localizedDescription)
                    self.hideSpinner()
                    return
                }
                UserMgr.signedIn(user, sender: self, completionHandler: { (vc) in
                    self.presentViewController(vc, animated: true, completion: nil)
                })
            }
        } else {
            hideSpinner()
        }
    }
    
    func didRequestPasswordReset() {
        showSpinner()
        let prompt = UIAlertController.init(title: nil, message: "Email:", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordResetWithEmail(userInput!) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
        prompt.addTextFieldWithConfigurationHandler(nil)
        prompt.addAction(okAction)
        presentViewController(prompt, animated: true, completion: {
            self.hideSpinner()
        });
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func prepareCancelLink() {
        
        cancelView = MaterialView()
        view.addSubview(cancelView)
        view.layout(cancelView).height(40).bottom(20).horizontally(left: 20, right: 20)
        
        let cancelButton: B2 = B2()
        cancelButton.addTarget(self, action: #selector(didTapCancel), forControlEvents: .TouchUpInside)
        cancelButton.setTitle("Cancel", forState: .Normal)
        
        cancelView.addSubview(cancelButton)
        cancelView.layout(cancelButton).center()
        
    }
    
    func didTapCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func prepareSpinner() {
        view.layout(spinner).center()
        spinner.activityIndicatorViewStyle = .WhiteLarge
        spinner.color = colors.medium
        spinner.hidesWhenStopped = true
    }
    
    func showSpinner() {
        // hide everytihng else
        cancelView.hidden = true
        loginView.hidden = true
        
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        
        // show everything again
        cancelView.hidden = false
        loginView.hidden = false
    }

}
