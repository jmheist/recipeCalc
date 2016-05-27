//
//  SettingsViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import FirebaseAuth
import Material

class SettingsViewController: UIViewController {
    
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
        prepareButtons()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.grey.lighten5
    }
    
    func prepareButtons() {
        let btn: FlatButton = FlatButton()
        btn.addTarget(self, action: #selector(signOut), forControlEvents: .TouchUpInside)
        btn.setTitle("Signout", forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
        view.addSubview(btn)
        
        MaterialLayout.alignFromTop(view, child: btn, top: 180)
        MaterialLayout.alignToParentHorizontally(view, child: btn, left: 40, right: 40)
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Settings"
        tabBarItem.image = MaterialIcon.settings
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
