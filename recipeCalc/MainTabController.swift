//
//  MainTabController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/24/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewWillAppear(animated: Bool) {
        if fb.isUserLoggedIn() {
            print("User is Logged in.")
        } else {
            print("User is logged in")
            performSegueWithIdentifier("showLogin", sender: self)
        }
    }
}
