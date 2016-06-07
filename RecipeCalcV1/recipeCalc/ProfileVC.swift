//
//  ProfileVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/1/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class ProfileVC: UIViewController {
    
    /// NavigationBar title label.
    private var titleLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Stops the tableView contentInsets from being automatically adjusted.
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareButtons()
        prepareProfile()
        prepareNavigationItem()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Profile"
    }
    
    func prepareButtons() {
        let btn: B1 = B1()
        btn.addTarget(self, action: #selector(signOut), forControlEvents: .TouchUpInside)
        btn.setTitle("Sign Out", forState: .Normal)
        view.addSubview(btn)
        
        MaterialLayout.alignFromBottom(view, child: btn, bottom: 60)
        MaterialLayout.alignToParentHorizontally(view, child: btn, left: 50, right: 50)
        
        let btn2: B1 = B1()
        btn2.addTarget(self, action: #selector(didTapUpdateProfile), forControlEvents: .TouchUpInside)
        btn2.setTitle("Update Profile", forState: .Normal)
        view.addSubview(btn2)
        
        MaterialLayout.alignFromBottom(view, child: btn2, bottom: 120)
        MaterialLayout.alignToParentHorizontally(view, child: btn2, left: 50, right: 50)
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Settings"
        tabBarItem.image = MaterialIcon.settings
    }
    
    func prepareProfile() {
        
        //////
        ////// Todo: Profile Stuff Goes here
        //////
    }
    
    func didTapUpdateProfile() {
        navigationController?.pushViewController(UpdateProfileVC(), animated: true)
    }
    
    func signOut(sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            print("signed out")
            let vc = LoginViewController()
            self.presentViewController(vc, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
}
