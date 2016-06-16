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

class DiscoveryViewController: TableVC {
    
    private var _refHandle: FIRDatabaseHandle!
    private var _refDeleteHandle: FIRDatabaseHandle!
    
    deinit {
        Queries.publicRecipes.removeAllObservers()
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

        ///////
        /////// Todo: IMPLIMENT PULL TO REFRESH EVENTUALLY
        ///////
        
        // Listen for new messages in the Firebase database
        _refHandle = Queries.publicRecipes.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            publicRecipeMgr.receiveFromFirebase(snapshot)
            self.recipeTable.reloadData()
        })
        
        _refDeleteHandle = Queries.publicRecipes.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("public recipe deleted")
        })
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicRecipeMgr.recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: PublicRecipeCell = PublicRecipeCell(style: .Default, reuseIdentifier: "publicRecipeCell")
        
        let recipe = publicRecipeMgr.recipes[indexPath.row]
        
        cell.starRatingView.value = recipe.stars
        
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.recipeName.font = RobotoFont.regular
        
        cell.recipeDesc.text = recipe.desc
        cell.recipeDesc.font = RobotoFont.regular
        cell.recipeDesc.textColor = MaterialColor.grey.darken1
        
        cell.creator.text = recipe.author
        cell.creator.font = RobotoFont.regular
        cell.creator.textColor = MaterialColor.grey.darken1
        
        cell.recipeID = recipe.key
        
        return cell
    }
    
    override func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "publicRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(PublicRecipeVC(recipe: publicRecipeMgr.recipes[indexPath.row]), animated: true)
    }
    
    func updateTable() {
        print("refresh tapped")
        Queries.publicRecipes.queryOrderedByChild("stars").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            publicRecipeMgr.reset()
            self.recipeTable.reloadData()
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                publicRecipeMgr.receiveFromFirebase(snap)
                self.recipeTable.reloadData()
            }
        })

    }
    
}
