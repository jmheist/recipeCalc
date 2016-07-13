//
//  Copyright (c) 2015 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit

import Firebase
import Material

class RegisterViewController: UIViewController, TextFieldDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    var loginView: MaterialView!
    var cancelView: MaterialView!
    
    private var
        nameField: T1!,
        emailField: T1!,
        passwordField: T1!;
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailRegistration()
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
    
    func prepareEmailRegistration() {
        
        loginView = MaterialView()
        view.addSubview(loginView)
        view.layout(loginView).top(20).left(20).right(20).bottom(60)
        
        let registerLabel: L1 = L1()
        registerLabel.text = "Register"
        registerLabel.textAlignment = .Center
        
        nameField = T1()
        nameField.placeholder = "Username"
        nameField.errorCheck = true
        nameField.errorCheckFor = "username"
        nameField.textLength = 3
        nameField.enableClearIconButton = true
        nameField.delegate = self
        
        // EMAIL FIELD //
        
        emailField = T1()
        emailField.placeholder = "Email"
        emailField.errorCheck = true
        emailField.errorCheckFor = "email"
        emailField.enableClearIconButton = true
        emailField.delegate = self
        
        // PASSWORD FIELD //
        
        passwordField = T1()
        passwordField.placeholder = "Password"
        passwordField.errorCheck = true
        passwordField.errorCheckFor = "password"
        passwordField.textLength = 6
        passwordField.enableVisibilityIconButton = true
        
        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = colors.dark
        
        let registerButton: B1 = B1()
        registerButton.addTarget(self, action: #selector(didTapSignUp), forControlEvents: .TouchUpInside)
        registerButton.setTitle("Sign Up", forState: .Normal)
        
        // LAYOUT //
        
        let children = [registerLabel, nameField, emailField, passwordField, registerButton]
        var dist = 10
        let spacing = 65
        for child in children {
            loginView.addSubview(child)
            loginView.layout(child).top(CGFloat(dist)).horizontally(left: 10, right: 10)
            dist += spacing
        }
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
    // Registration Functions
    //
    
    func didTapSignUp() {
        
        showSpinner()
        
        let fields = [nameField, emailField, passwordField]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() {
        
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    alertMgr.alert("Sign in error", message: error.localizedDescription)
                    self.hideSpinner()
                    return
                }
                self.setDisplayName(user!)
            }
            
        } else {
            hideSpinner()
        }
    }
    
    func setDisplayName(user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = nameField.text!
        changeRequest.commitChangesWithCompletion(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                alertMgr.alert("Sign in error", message: error.localizedDescription)
                return
            }
            let user = FIRAuth.auth()?.currentUser
            UserMgr.signedIn(user, sender: self, completionHandler: { (vc) in
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }
    
    func didTapCancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
