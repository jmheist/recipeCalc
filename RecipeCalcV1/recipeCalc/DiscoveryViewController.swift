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
    private var _refUpdateHandle: FIRDatabaseHandle!
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
        ///////
        /////// Todo: IMPLIMENT PULL TO REFRESH EVENTUALLY
        ///////
        
        // Listen for new messages in the Firebase database
        _refHandle = Queries.publicRecipes.observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
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
            publicRecipeMgr.addRecipe(rec)
            self.recipeTable.reloadData()
        })
        
        _refUpdateHandle = Queries.publicRecipes.observeEventType(.ChildChanged, withBlock: { (snapshot) -> Void in
            print("Public Recipe Changed")
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
            publicRecipeMgr.updateRecipe(rec)
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

}
