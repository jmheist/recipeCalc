//
//  LocalRecipeListViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase
import FirebaseDatabaseUI

class LocalRecipeListVC: TableVC {
    
    override func prepareView() {
        super.prepareView()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "Recipes"
    }
    
    override func getQuery() -> FIRDatabaseQuery {
        let recentPostsQuery = (ref?.child("recipes"))!
        return recentPostsQuery
    }
    
    
}