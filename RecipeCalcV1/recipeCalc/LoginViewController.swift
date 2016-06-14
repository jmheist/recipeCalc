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
    
    private var nameField: T1!,
                emailField: T1!,
                passwordField: T1!;
    
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Checking if user is logged in")
        if let user = FIRAuth.auth()?.currentUser {
            print("User is signed in \(user.displayName)")
            self.signedIn(user)
        } else {
            print("Not signed in yet")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailRegistration()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    //
    // Login Forms
    //
    
    func prepareEmailRegistration() {
        
        let width: CGFloat = 300
        let height: CGFloat = 350
        
        let loginView: MaterialView = MaterialView(frame: CGRectMake(0, 0, width, height))
        
        loginView.center = view.center
        
        view.addSubview(loginView)

        // EMAIL FIELD //
        
        emailField = T1()
        emailField.placeholder = "Email"
        emailField.enableClearIconButton = true
        emailField.delegate = self
        
        loginView.addSubview(emailField)
        
        // PASSWORD FIELD //
        
        passwordField = T1()
        passwordField.placeholder = "Password"
        passwordField.enableVisibilityIconButton = true
        
        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = colors.dark 
        
        loginView.addSubview(passwordField)
        
        // BUTTONS //
        
        let btn: FlatButton = B1()
        btn.addTarget(self, action: #selector(didTapSignIn), forControlEvents: .TouchUpInside)
        btn.setTitle("Sign In", forState: .Normal)
        
        loginView.addSubview(btn)
        
        let btn2: FlatButton = B1()
        btn2.addTarget(self, action: #selector(didTapSignUp), forControlEvents: .TouchUpInside)
        btn2.setTitle("Sign Up", forState: .Normal)
        
        loginView.addSubview(btn2)
        
        // LAYOUT //
        
        Layout.horizontally(loginView, child: emailField, left: 10, right: 10)
        Layout.horizontally(loginView, child: passwordField, left: 10, right: 10)
        Layout.horizontally(loginView, child: btn)
        Layout.horizontally(loginView, child: btn2)
        
        Layout.top(loginView, child: emailField, top: 30)
        Layout.top(loginView, child: passwordField, top: 100)
        Layout.top(loginView, child: btn, top: 180)
        Layout.top(loginView, child: btn2, top: 245)

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
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.uid = user?.uid
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.signedIn = true
        print("user: \(user?.displayName), uid: \(user?.uid)")
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        loadApp()
    }
    
    func loadApp() {
        let localRecipeList: AppNav = AppNav(rootViewController: LocalRecipeListVC())
        let createRecipeViewController: AppNav = AppNav(rootViewController: CreateRecipeViewController())
        let discoveryViewController: AppNav = AppNav(rootViewController: DiscoveryViewController())
        let profileVC: AppNav = AppNav(rootViewController: ProfileVC())
        
        let bottomNavigationController: BottomNav = BottomNav()
        bottomNavigationController.viewControllers = [localRecipeList, createRecipeViewController, discoveryViewController, profileVC]
        bottomNavigationController.selectedIndex = 0
        presentViewController(bottomNavigationController, animated: true, completion: nil)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //
    // End Login Functions
    //
    
}
