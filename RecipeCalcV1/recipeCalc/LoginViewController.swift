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

    private var emailField: T1!,
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
        prepareEmailLogin()
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
    
    func signedIn(user: FIRUser?) {
        MeasurementHelper.sendLoginEvent()
        AppState.sharedInstance.displayName = user?.displayName ?? user?.email
        AppState.sharedInstance.uid = user?.uid
        AppState.sharedInstance.photoUrl = user?.photoURL
        AppState.sharedInstance.email = user?.email
        AppState.sharedInstance.signedIn = true
        print(user, user?.email, user?.displayName)
        UserMgr.sendToFirebase(User(username: AppState.sharedInstance.displayName!, email: AppState.sharedInstance.email!), uid: AppState.sharedInstance.uid!)
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
}
