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

class LoginViewController: UIViewController, TextFieldDelegate {
    
    private var nameField: TextField!,
                emailField: TextField!,
                passwordField: TextField!;
    
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("checking for logined in")
        if let user = FIRAuth.auth()?.currentUser {
            
            self.signedIn(user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailRegistration()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.medGrey
    }
    
    
    //
    // Login Forms
    //
    
    func prepareEmailRegistration() {
        
        let loginView: MaterialView = MaterialView();
        
        view.addSubview(loginView)
        loginView.backgroundColor = MaterialColor.white
        
        MaterialLayout.alignToParent(view, child: loginView, top: 140, bottom: 140, left: 14, right: 14)
        
        // EMAIL FIELD //
        
        emailField = TextField()
        emailField.placeholder = "Email"
        emailField.enableClearIconButton = true
        emailField.delegate = self
        
        loginView.addSubview(emailField)
        
        // PASSWORD FIELD //
        
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.clearButtonMode = .WhileEditing
        passwordField.enableVisibilityIconButton = true
        
        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = MaterialColor.green.base.colorWithAlphaComponent(passwordField.secureTextEntry ? 0.38 : 0.54)
        
        loginView.addSubview(passwordField)
        
        // BUTTONS //
        
        let btn: FlatButton = FlatButton()
        btn.addTarget(self, action: #selector(didTapSignIn), forControlEvents: .TouchUpInside)
        btn.setTitle("Signin", forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
        
        loginView.addSubview(btn)
        
        let btn2: FlatButton = FlatButton()
        btn2.addTarget(self, action: #selector(didTapSignUp), forControlEvents: .TouchUpInside)
        btn2.setTitle("Signup", forState: .Normal)
        btn2.setTitleColor(MaterialColor.blue.base, forState: .Normal)
        btn2.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
        
        loginView.addSubview(btn2)
        
        // LAYOUT //
        
        MaterialLayout.alignToParentHorizontally(loginView, child: emailField, left: 10, right: 10)
        MaterialLayout.alignToParentHorizontally(loginView, child: passwordField, left: 10, right: 10)
        MaterialLayout.alignToParentHorizontally(loginView, child: btn)
        MaterialLayout.alignToParentHorizontally(loginView, child: btn2)
        
        MaterialLayout.alignFromTop(loginView, child: emailField, top: 30)
        MaterialLayout.alignFromTop(loginView, child: passwordField, top: 100)
        MaterialLayout.alignFromTop(loginView, child: btn, top: 180)
        MaterialLayout.alignFromTop(loginView, child: btn2, top: 220)

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
            // Sign In with credentials.
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.signedIn(user!)
            }
        }
        
        func didTapSignUp() {
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.setDisplayName(user!)
            }
        }
        
        func setDisplayName(user: FIRUser) {
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = user.email!.componentsSeparatedByString("@")[0]
            changeRequest.commitChangesWithCompletion(){ (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                self.signedIn(FIRAuth.auth()?.currentUser)
            }
        }
        
        func didRequestPasswordReset(sender: AnyObject) {
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
            presentViewController(prompt, animated: true, completion: nil);
        }
        
        func signedIn(user: FIRUser?) {
            MeasurementHelper.sendLoginEvent()
            print("User is signed in")
            AppState.sharedInstance.displayName = user?.displayName ?? user?.email
            AppState.sharedInstance.photoUrl = user?.photoURL
            AppState.sharedInstance.signedIn = true
            
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
            dismissViewControllerAnimated(true, completion: nil)
        }
    
    //
    // End Login Functions
    //
    
}
