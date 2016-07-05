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
import FBSDKLoginKit

class RegisterViewController: UIViewController, TextFieldDelegate, FBSDKLoginButtonDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    
    private var nameField: T1!,
                emailField: T1!,
                passwordField: T1!,
                fbErrorLabel: L3!;
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailRegistration()
        prepareCancelLink()
        prepareFacebookLogin()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    //
    // Login Forms
    //
    
    func prepareEmailRegistration() {
        
        let loginView: MaterialView = MaterialView()
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
        
        let registerButton: B2 = B2()
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
    
    func prepareFacebookLogin() {
        
        let fbView: MaterialView = MaterialView()
        view.layout(fbView).bottom(110).horizontally(left: 20, right: 20).height(100)
        
        let fbLabel: L3 = L3()
        fbLabel.text = "Register with Facebook"
        fbLabel.textAlignment = .Center
        fbView.layout(fbLabel).top(0).horizontally()
        
        let fbButton: FBSDKLoginButton = FBSDKLoginButton()
        fbView.layout(fbButton).top(30).center().width(200).height(50)
        
        fbErrorLabel = L3()
        fbErrorLabel.hidden = true
        fbErrorLabel.text = ""
        fbErrorLabel.textAlignment = .Center
        fbErrorLabel.lineBreakMode = .ByWordWrapping
        fbErrorLabel.numberOfLines = 0;
        fbErrorLabel.textColor = colors.error
        fbView.layout(fbErrorLabel).top(85).horizontally()
        
        fbButton.delegate = self
        fbButton.readPermissions = ["public_profile","email","user_friends"]
        
    }
    
    func prepareCancelLink() {
        
        let cancelView: MaterialView = MaterialView()
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
        self.fbErrorLabel.text = ""
        self.fbErrorLabel.hidden = true
        let fields = [nameField, emailField, passwordField]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
//        if !errorMgr.hasErrors() {
//        
//            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                self.setDisplayName(user!)
//            }
//            
//        }
    }
    
    func setDisplayName(user: FIRUser) {
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = nameField.text!
        changeRequest.commitChangesWithCompletion(){ (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let user = FIRAuth.auth()?.currentUser
            UserMgr.signedIn(user, sender: self)
        }
    }
    
    func didTapCancel() {
        self.fbErrorLabel.text = ""
        self.fbErrorLabel.hidden = true
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    // FB Stuff
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.fbErrorLabel.text = ""
        self.fbErrorLabel.hidden = true
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        
        if result.isCancelled {
            return
        }
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                FBSDKAccessToken.setCurrentAccessToken(nil)
                self.fbErrorLabel.text = error?.localizedDescription
                self.fbErrorLabel.hidden = false
                return
            }
            print("user logged in via fb")
            UserMgr.signedIn(user, provider: true, sender: self)
        })
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()?.signOut()
        print("User logged out of facebook")
    }    
}
