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
    
    private var _refHandle: FIRDatabaseHandle!
    
    deinit {
        Queries.myRecipes.removeObserverWithHandle(_refHandle)
    }
    
    override func prepareView() {
        super.prepareView()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "My Recipes"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let key = myRecipes[indexPath.row].key
            Queries.myRecipes.child(key).removeValue()
            Queries.recipes.child(key).removeValue()
            Queries.flavors.child(key).removeValue()
            myRecipes.removeAtIndex(indexPath.row)
            self.recipeTable.reloadData()
        }
    }
    
    override func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = Queries.myRecipes.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            myRecipes.append(snapshot)
            self.recipeTable.insertRowsAtIndexPaths([NSIndexPath(forRow: myRecipes.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "myRecipeCell")
        // Unpack message from Firebase DataSnapshot
        let recipeSnapshot: FIRDataSnapshot! = myRecipes[indexPath.row]
        let recipe = recipeSnapshot.value as! Dictionary<String, String>
        
        cell.selectionStyle = .None
        cell.recipeName.text = recipe["recipeName"]
        cell.recipeName.font = RobotoFont.regular
        
        cell.recipeDesc.text = recipe["recipeDesc"]
        cell.recipeDesc.font = RobotoFont.regular
        cell.recipeDesc.textColor = MaterialColor.grey.darken1
        
        cell.creator.text = recipe["creator"]
        cell.creator.font = RobotoFont.regular
        cell.creator.textColor = MaterialColor.grey.darken1
        
        cell.recipeID = recipeSnapshot.key
        
        cell.publishButton.addTarget(self, action: #selector(publishRecipe), forControlEvents: .TouchUpInside)
        cell.publishButton.tag = indexPath.row
        
        return cell
    }
    
    override func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "myRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(MyRecipeVC(recipe: myRecipes[indexPath.row]), animated: true)
    }
    
    func publishRecipe(sender: UIButton) {
        let recipe = myRecipes[sender.tag]
        Queries.recipes.child(recipe.key).setValue(recipe.value)
    }
    
}