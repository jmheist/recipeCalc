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

class LocalRecipeListVC: TableVC {
    
    private var _refHandle: FIRDatabaseHandle!
    private var _refRemovedHandle: FIRDatabaseHandle!
    
    deinit {
        Queries.myRecipes.child(AppState.sharedInstance.uid!).removeAllObservers()
    }
    
    override func prepareView() {
        super.prepareView()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu
    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "My Recipes"
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let key = myRecipeMgr.recipes[indexPath.row].key
            myRecipeMgr.removeRecipe(key)
            recipeTable.reloadData()
        }
    }
    
    override func configureDatabase() {
        // Listen for new messages in the Firebase database
        _refHandle = Queries.myRecipes.child(AppState.sharedInstance.uid!).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            print(snapshot)
            let key = snapshot.key as String
            let author = snapshot.value!["author"] as! String
            let authorId = snapshot.value!["authorId"] as! String
            let name = snapshot.value!["name"] as! String
            let desc = snapshot.value!["desc"] as! String
            let pg = snapshot.value!["pg"] as! String
            let vg = snapshot.value!["vg"] as! String
            let strength = snapshot.value!["strength"] as! String
            let steepDays = snapshot.value!["steepDays"] as! String
            let published = snapshot.value!["published"] as! String
            let rec = Recipe(key: key, author: author, authorId: authorId, name: name, desc: desc, pg: pg, vg: vg, strength: strength, steepDays: steepDays, published: published)
            myRecipeMgr.addRecipe(rec)
            self.recipeTable.reloadData()
        })
        _refRemovedHandle = Queries.myRecipes.child(AppState.sharedInstance.uid!).observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("Recipe Removed")
        })
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myRecipeMgr.recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "myRecipeCell")
        
        let recipe = myRecipeMgr.recipes[indexPath.row]
        
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
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "myRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(MyRecipeVC(recipe: myRecipeMgr.recipes[indexPath.row]), animated: true)
    }
        
}