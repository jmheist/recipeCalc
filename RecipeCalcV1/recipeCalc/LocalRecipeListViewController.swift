//
//  LocalRecipeListViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import FirebaseAuth

class LocalRecipeListViewController: UIViewController {
    
    
    
    //
    // bottom nav setup
    //
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        //check if user is logged in
        if AppState.sharedInstance.signedIn {
            print("User Is Already Logged In")
        } else {
            print("User is not logged in yet, should load loginVC")
            let vc = LoginViewController()
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.grey.lighten5
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    //
    // end bottom nav setup
    //

}
