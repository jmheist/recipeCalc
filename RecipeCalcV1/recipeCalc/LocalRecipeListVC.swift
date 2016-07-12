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
    
    override func prepareView() {
        super.prepareView()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
        configureDatabase()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu
    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "My Recipes"
        let viewFavsButton = UIBarButtonItem(title: "view favs", style: .Plain, target: self, action: #selector(showFavs))
        navigationItem.rightBarButtonItem = viewFavsButton
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let key = self.recipes[indexPath.row].key
            recipeMgr.deleteRecipe(key, completionHandler: { (recs) in
                self.recipes = recs
                self.recipeTable.reloadData()
            })
        }
    }
    
    override func configureDatabase() {
        recipeMgr.getUserRecipes(AppState.sharedInstance.uid!, sort: "stars") { (recs) in
            self.recipes = recs
            self.recipeTable.reloadData()
        }
    }
    
    func showFavs() {
        navigationController?.pushViewController(FavListVC(), animated: true)
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "myRecipeCell")
        
        let recipe = self.recipes[indexPath.row]
        
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.recipeDesc.text = recipe.desc
        cell.creator.text = recipe.author
        cell.recipeID = recipe.key
        
        return cell
    }
    
    override func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "myRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(MyRecipeVC(recipe: self.recipes[indexPath.row]), animated: true)
    }
        
}