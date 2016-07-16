//
//  AppLandingVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/23/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase
import FBSDKLoginKit

class AppLandingVC: UIViewController, FBSDKLoginButtonDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    
    var spinner: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var fbErrorLabel: L3!;
    var fbView: MaterialView!
    var welcomeView: MaterialView!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareView()
        prepareWelcomeWagon()
        prepareFacebookLogin()
        prepareSpinner()
        showSpinner()
        print("Checking if user is logged in")
        if let user = FIRAuth.auth()?.currentUser {
            print("User is signed in \(user.displayName)")
            UserMgr.signedIn(user, provider: false, completionHandler: { (vc) in
                self.presentViewController(vc, animated: true, completion: nil)
            })
        } else {
            self.hideSpinner()
            print("Not signed in yet")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /// Prepares view.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    func prepareWelcomeWagon() {
        
        welcomeView = MaterialView()
        view.layout(welcomeView).center().height(200).left(20).right(20)
        
        let welcomeLabel: L1 = L1()
        welcomeLabel.text = "Welcome"
        welcomeView.layout(welcomeLabel).top(0).centerHorizontally()
        
        let loginButton: B1 = B1()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(login), forControlEvents: .TouchUpInside)
        welcomeView.layout(loginButton).bottom(0).left(50).width(100)
        let regButton: B1 = B1()
        regButton.setTitle("Register", forState: .Normal)
        regButton.addTarget(self, action: #selector(register), forControlEvents: .TouchUpInside)
        welcomeView.layout(regButton).bottom(0).right(50).width(100)
        
    }
    
    func prepareFacebookLogin() {
        
        fbView = MaterialView()
        view.layout(fbView).bottom(60).horizontally(left: 20, right: 20).height(100)
        
        let fbLabel: L3 = L3()
        fbLabel.text = "Register with Facebook"
        fbLabel.textAlignment = .Center
        fbView.layout(fbLabel).top(0).horizontally()
        
        let fbButton: FBSDKLoginButton = FBSDKLoginButton()
        fbView.layout(fbButton).top(30).centerHorizontally().width(200).height(50)
        
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
    
    func login() {
        self.presentViewController(LoginViewController(), animated: true, completion: nil)
    }
    
    func register() {
        self.presentViewController(RegisterViewController(), animated: true, completion: nil)
    }
    
    func prepareSpinner() {
        view.layout(spinner).center()
        spinner.activityIndicatorViewStyle = .WhiteLarge
        spinner.color = colors.medium
        spinner.hidesWhenStopped = true
    }
    
    func showSpinner() {
        // hide everytihng else 
        welcomeView.hidden = true
        fbView.hidden = true
        
        spinner.startAnimating()
    }
    
    func hideSpinner() {
        spinner.stopAnimating()
        
        // show everything again
        welcomeView.hidden = false
        fbView.hidden = false
    }
    
    // FB Stuff
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        self.fbErrorLabel.text = ""
        self.fbErrorLabel.hidden = true
        
        showSpinner()
        
        if error != nil {
            print(error!.localizedDescription)
            alertMgr.alert("Sign in error", message: error.localizedDescription)
            self.fbErrorLabel.text = error?.localizedDescription
            self.fbErrorLabel.hidden = false
            hideSpinner()
            return
        }
        
        if result.isCancelled {
            hideSpinner()
            return
        }
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        
        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
            if error != nil {
                print(error?.localizedDescription)
                alertMgr.alert("Sign in error", message: (error?.localizedDescription)!)
                FBSDKAccessToken.setCurrentAccessToken(nil)
                self.fbErrorLabel.text = error?.localizedDescription
                self.fbErrorLabel.hidden = false
                return
            }
            print("user logged in via fb")
            UserMgr.signedIn(user, provider: true, completionHandler: { (vc) in
                self.presentViewController(vc, animated: true, completion: nil)
            })
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
