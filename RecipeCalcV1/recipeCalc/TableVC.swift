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

class TableVC: UIViewController, UITableViewDelegate {
    
    // VARS
    var recipeTable: UITableView!
    var ref: FIRDatabaseReference!
    var dataSource: FirebaseTableViewDataSource!
    
    
    //
    // bottom nav setup
    //
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDatabase()
        prepareView()
        prepareNavigationItem()
        prepareTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        //check if user is logged in
        if AppState.sharedInstance.signedIn {
            // print("User is logged in")
        } else {
            print("User is not logged in yet, should load loginVC")
            let vc = LoginViewController()
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    
    /// General preparation statements.
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    /// Prepare tabBarItem.
    func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = "Recipes"
    }
    
    /// Prepare table
    func prepareTableView() {
        recipeTable = UITableView()
        
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 0, left: 0, bottom: 49, right: 0)
        
        dataSource = FirebaseTableViewDataSource.init(
            query: getQuery(), modelClass: Recipe.self, cellClass: RecipeCell.self, cellReuseIdentifier: "recipe", view: self.recipeTable
        )

        dataSource?.populateCellWithBlock(){
            let cell = $0 as! RecipeCell
            let recipe = $1 as! Recipe
            cell.recipeName.text = recipe.recipeName
            cell.creator.text = recipe.creator
            cell.recipeDesc.text = recipe.recipeDesc
        }
        
        recipeTable.dataSource = dataSource
        recipeTable.delegate = self
        
        // UITableViewDelegate Functions
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            
            if(editingStyle == UITableViewCellEditingStyle.Delete){
                // Recipe.
            }
            
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recipeTable.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func getQuery() -> FIRDatabaseQuery {
        let recentPostsQuery = (ref)!
        return recentPostsQuery
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //
        }
    }
    
}