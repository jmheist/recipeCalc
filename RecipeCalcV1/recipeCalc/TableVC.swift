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

class TableVC: UIViewController {
    
    // VARS
    var recipeTable: UITableView!

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
    
    override func viewWillAppear(animated: Bool) {
        self.recipeTable.reloadData()
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
        registerMyClass()
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 0, left: 0, bottom: 49, right: 0)
        
    }
    
    func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "recipeCell")
    }
}


/// TableViewDataSource methods.
extension TableVC: UITableViewDataSource {

    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: RecipeCell = RecipeCell(style: .Default, reuseIdentifier: "recipeCell")
        // Unpack message from Firebase DataSnapshot
        let recipeSnapshot: FIRDataSnapshot! = recipes[indexPath.row]
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
        
        cell.recipeID = recipe
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension TableVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
}
