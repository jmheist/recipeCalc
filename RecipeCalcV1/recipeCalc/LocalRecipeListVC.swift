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

class LocalRecipeListVC: UIViewController {
    
    // VARS
    private var recipeTable: UITableView!
    let cellIdentifier = "RecipeCell"
    var ref: FIRDatabaseReference!
    var recipes: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    
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
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("recipes").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            self.recipes.append(snapshot)
            self.recipeTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.recipes.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
   
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = "Recipes"
    }
    
    /// Prepare table
    func prepareTableView() {
        
        recipeTable = UITableView()
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 0, bottom: 49)
    }
    
    
    //
    // end bottom nav setup
    //

}

/// TableViewDataSource methods.
extension LocalRecipeListVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // setup data from snapshot
        let recipeSnapshot: FIRDataSnapshot! = self.recipes[indexPath.row]
        let recipe = recipeSnapshot.value as! Dictionary<String, String>
        let name = recipe["name"] as String!
        let desc = recipe["desc"] as String!
        
        let cell: RecipeCell = RecipeCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = desc
        return cell
    }
    
}

/// UITableViewDelegate methods.
extension LocalRecipeListVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}
