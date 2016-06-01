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
        prepareView()
        prepareTitlebar()
        prepareTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        //check if user is logged in
        if AppState.sharedInstance.signedIn {
            print("User is logged in")
        } else {
            print("User is not logged in yet, should load loginVC")
            let vc = LoginViewController()
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "RecipeCalc"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    /// Prepare table
    func prepareTableView() {
        
        recipeTable = UITableView()
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 60, bottom: 49)
    }
    
    
    //
    // end bottom nav setup
    //

}

/// TableViewDataSource methods.
extension LocalRecipeListVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecipeCell = RecipeCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Row: \(indexPath.row)"
        cell.detailTextLabel?.text = "Description for row \(indexPath.row)"
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
