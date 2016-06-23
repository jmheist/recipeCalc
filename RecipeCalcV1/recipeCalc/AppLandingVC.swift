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

class AppLandingVC: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Checking if user is logged in")
        if let user = FIRAuth.auth()?.currentUser {
            print("User is signed in \(user.displayName)")
            UserMgr.signedIn(user, sender: self)
        } else {
            print("Not signed in yet")
            prepareWelcomeWagon()
        }
    }
    
    /// Prepares view.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    func prepareWelcomeWagon() {
        
        let welcomeLabel: L1 = L1()
        welcomeLabel.text = "Welcome"
        view.layout(welcomeLabel).center(offsetX: 0, offsetY: -100)
        
        let loginButton: B1 = B1()
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(login), forControlEvents: .TouchUpInside)
        view.layout(loginButton).center(offsetX: 60, offsetY: 100).width(90)
        
        let regButton: B1 = B1()
        regButton.setTitle("Register", forState: .Normal)
        regButton.addTarget(self, action: #selector(register), forControlEvents: .TouchUpInside)
        view.layout(regButton).center(offsetX: -60, offsetY: 100).width(90)
        
    }
    
    func login() {
        self.presentViewController(LoginViewController(), animated: true, completion: nil)
    }
    
    func register() {
        self.presentViewController(RegisterViewController(), animated: true, completion: nil)
    }
    
}
