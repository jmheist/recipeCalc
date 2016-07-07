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
import FBSDKLoginKit

class LoginViewController: UIViewController, TextFieldDelegate, FBSDKLoginButtonDelegate {

    private var emailField: T1!,
                passwordField: T1!,
                fbErrorLabel: L3!;
    
    
    override func viewWillAppear(animated: Bool) {
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareEmailLogin()
        prepareFacebookLogin()
        prepareCancelLink()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    //
    // Login Forms
    //
    
    func prepareEmailLogin() {
        
        let loginView: MaterialView = MaterialView()
        view.addSubview(loginView)
        view.layout(loginView).top(20).left(20).right(20).bottom(60)
        
        let loginLabel: L1 = L1()
        loginLabel.text = "Login"
        loginLabel.textAlignment = .Center
        
        // EMAIL FIELD //
        
        emailField = T1()
        emailField.placeholder = "Email"
        emailField.enableClearIconButton = true
        emailField.delegate = self
        
        // PASSWORD FIELD //
        
        passwordField = T1()
        passwordField.placeholder = "Password"
        passwordField.enableVisibilityIconButton = true
        
        // Setting the visibilityFlatButton color.
        passwordField.visibilityIconButton?.tintColor = colors.dark
        
        // BUTTONS //
        
        let signInButton: B2 = B2()
        signInButton.addTarget(self, action: #selector(didTapSignIn), forControlEvents: .TouchUpInside)
        signInButton.setTitle("Sign In", forState: .Normal)
        
        let forgotPasswordButton: B2 = B2()
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
    
    func prepareFacebookLogin() {
        
        let fbView: MaterialView = MaterialView()
        view.layout(fbView).bottom(110).horizontally(left: 20, right: 20).height(100)
        
        let fbLabel: L3 = L3()
        fbLabel.text = "Login with Facebook"
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
        fbButton.placeholderText = "Login with Facebook"
        fbButton.readPermissions = ["public_profile","email","user_friends"]
        
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
            UserMgr.signedIn(user, sender: self)
        }
    }
    
    func didRequestPasswordReset() {
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
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
    
    func didTapCancel() {
        dismissViewControllerAnimated(true, completion: nil)
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
