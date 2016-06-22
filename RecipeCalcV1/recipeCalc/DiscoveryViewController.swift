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
import Refresher

class DiscoveryViewController: TableVC {
    
    private var _refHandle: FIRDatabaseHandle!
    private var _refDeleteHandle: FIRDatabaseHandle!
    
    private var searchBar: SearchBar!
    
    deinit {
        Queries.publicRecipes.removeAllObservers()
    }
    
    override func prepareView() {
        super.prepareView()
        prepareNavigationItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRefresher()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        tabBarItem.title = "Discover"
        tabBarItem.image = MaterialIcon.visibility
    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "Discover"
        
        let searchIcon = UIBarButtonItem(image: MaterialIcon.cm.search, style: .Plain, target: self, action: #selector(search))
        navigationItem.rightBarButtonItems = [searchIcon]
    }
    
    func search() {
        presentViewController(SearchVC(), animated: true, completion: nil)
    }
    
    override func configureDatabase() {
        
        // Listen for new messages in the Firebase database
        _refHandle = (Queries.publicRecipes).queryOrderedByChild("stars").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            let rec = publicRecipeMgr.receiveFromFirebase(snapshot)
            publicRecipeMgr.addRecipe(rec)
            publicRecipeMgr.sortBy("stars")
            self.recipeTable.reloadData()
        })
        
        _refDeleteHandle = Queries.publicRecipes.observeEventType(.ChildRemoved, withBlock: { (snapshot) -> Void in
            print("public recipe deleted")
        })
    }
    
    func prepareRefresher() {
        let pacmanAnimator = PacmanAnimator(frame: CGRectMake(0, 0, 80, 80))
        recipeTable.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                print("refreshing")
                self.updateTable()
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.recipeTable.stopPullToRefresh()
                }
            }
        }, withAnimator: pacmanAnimator)
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
        (Queries.publicRecipes).queryOrderedByChild("stars").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            publicRecipeMgr.reset()
            self.recipeTable.reloadData()
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let rec = publicRecipeMgr.receiveFromFirebase(snap)
                publicRecipeMgr.addRecipe(rec)
                publicRecipeMgr.sortBy("stars")
                self.recipeTable.reloadData()
            }
        })

    }
    
}
