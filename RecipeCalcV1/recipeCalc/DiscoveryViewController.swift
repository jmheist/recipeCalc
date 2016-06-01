//
//  DiscoveryViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/26/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class DiscoveryViewController: UIViewController {

    private var recipeTable: UITableView!
    let cellIdentifier = "PublicRecipeCell"
    
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
        prepareRecipeTable()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "Discover New Recipes"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Discover"
        tabBarItem.image = MaterialIcon.visibility
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    //
    // end bottom nav setup
    //
    
    func prepareRecipeTable() {
        
        recipeTable = UITableView()
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 60, bottom: 49)
        
    }
    
}


/// TableViewDataSource methods.
extension DiscoveryViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecipeCell = RecipeCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Recipe Name \(indexPath.row)"
        cell.detailTextLabel?.text = "Created by JMHEIST\t\t\t 10 stars"
        return cell
    }
    
}

/// UITableViewDelegate methods.
extension DiscoveryViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}

