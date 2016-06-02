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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTitlebar()
        prepareButtons()
        prepareProfile()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "Profile"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    func prepareButtons() {
        let btn: FlatButton = FlatButton()
        btn.addTarget(self, action: #selector(signOut), forControlEvents: .TouchUpInside)
        btn.setTitle("Signout", forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
        view.addSubview(btn)
        
        MaterialLayout.alignFromTop(view, child: btn, top: 60)
        MaterialLayout.alignToParentHorizontally(view, child: btn, left: 40, right: 40)
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Settings"
        tabBarItem.image = MaterialIcon.settings
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareProfile() {
        
        let profileView: MaterialView = MaterialView()
        view.addSubview(profileView)
        MaterialLayout.alignToParent(view, child: profileView, top: 60, left: 0, right: 0, bottom: 49)
        
        
        let btn: B1 = B1()
        btn.addTarget(self, action: #selector(didTapUpdateProfile), forControlEvents: .TouchUpInside)
        btn.setTitle("Update Profile", forState: .Normal)

        profileView.addSubview(btn)
        MaterialLayout.alignFromTop(profileView, child: btn, top: 20)
        MaterialLayout.alignToParentHorizontally(profileView, child: btn, left: 50, right: 50)
        
    }
    
    func didTapUpdateProfile() {
        self.presentViewController(UpdateProfileVC(), animated: true, completion: nil)
    }
    
    func signOut(sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            print("signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
}
