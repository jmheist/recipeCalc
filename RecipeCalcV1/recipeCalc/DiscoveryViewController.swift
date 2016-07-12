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
    
    private var searchBar: SearchBar!
    
    deinit {
        Queries.publicRecipes.removeAllObservers()
    }
    
    override func prepareView() {
        super.prepareView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRefresher()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
        configureDatabase()
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
        recipeMgr.getPublishedRecipes("stars") { (recs) in
            self.recipes = recs
            self.recipeTable.reloadData()
        }
        
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
        return self.recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: PublicRecipeCell = PublicRecipeCell(style: .Default, reuseIdentifier: "publicRecipeCell")
        
        let recipe = self.recipes[indexPath.row]
        
        cell.starRatingView.value = recipe.stars
        cell.starRatingCount.text = "(\(recipe.starsCount))"
        cell.heartCount.text = "\(recipe.favCount)"
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.recipeDesc.text = recipe.desc
        cell.creator.text = recipe.author
        cell.recipeID = recipe.key
        
        return cell
    }
    
    override func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "publicRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        analyticsMgr.sendPublicRecipeViewed()
        navigationController?.pushViewController(PublicRecipeVC(recipe: self.recipes[indexPath.row]), animated: true)
    }
    
    func updateTable() {
        recipeMgr.getPublishedRecipes("stars") { (recs) in
            self.recipes = recs
            self.recipeTable.reloadData()
        }
    }
    
}
