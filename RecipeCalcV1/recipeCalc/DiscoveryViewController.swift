//
//  DiscoveryViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/26/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase
import FirebaseAuthUI

class DiscoveryViewController: TableVC {

    override func prepareView() {
        super.prepareView()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "Discover"
        tabBarItem.image = MaterialIcon.visibility    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "Discover"
    }
    
    override func getQuery() -> FIRDatabaseReference {
        return ref.child("recipes")
    }

}
