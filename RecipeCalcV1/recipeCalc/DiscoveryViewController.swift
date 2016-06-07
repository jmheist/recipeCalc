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
    
    private var _refHandle: FIRDatabaseHandle!
    private var _refDeleteHandle: FIRDatabaseHandle!
    
    deinit {
        ref.child("myRecipes").removeObserverWithHandle(_refHandle)
    }
    
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
    
    override func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
        ///////
        /////// Todo: IMPLIMENT PULL TO REFRESH EVENTUALLY
        ///////
        
        _refHandle = Queries.recipes.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            recipes.append(snapshot)
            self.recipeTable.insertRowsAtIndexPaths([NSIndexPath(forRow: recipes.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
        _refDeleteHandle = Queries.recipes.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("public recipe deleted")
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(MyRecipeVC(recipe: recipes[indexPath.row]), animated: true)
    }

}
