//
//  RecipeVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/6/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class RecipeVC: UIViewController {
    
    var recipe: Recipe!
    var flavors: [FIRDataSnapshot]! = []
    var _refHandle: FIRDatabaseHandle!
    
    var recipeTable: UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFlavors()
        prepareView()
        prepareNavigationItem()
        prepareRecipe()
        prepareTableView()
    }
    
    deinit {
        Queries.flavors.child(recipe.key).removeObserverWithHandle(_refHandle)
    }
    
    // Queries.flavors.child(recipes[indexPath.row].key)
    func prepareFlavors() {
        _refHandle = Queries.flavors.child(recipe.key).observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            self.flavors.append(snapshot)
            self.recipeTable.insertRowsAtIndexPaths([NSIndexPath(forRow: self.flavors.count-1, inSection: 0)], withRowAnimation: .Automatic)
        })
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
        print(flavors.count)
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = ""
    }
    
    func prepareRecipe() {
                
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        MaterialLayout.alignToParent(view, child: recipeInfo, top: 0, left: 0, bottom: 49, right: 0)
        
        let recipeName: L1 = L1()
        let recipeDesc: L2 = L2()
        
        recipeName.text = recipe.name
        recipeDesc.text = recipe.desc
        recipeName.textAlignment = .Center
        recipeDesc.textAlignment = .Center
        
        recipeInfo.addSubview(recipeName)
        recipeInfo.addSubview(recipeDesc)
        
        
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 15)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 45)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc)
        
    }
    
    /// Prepare table
    func prepareTableView() {
        
        recipeTable = UITableView()
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "flavorCell")
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        view.addSubview(recipeTable)
        MaterialLayout.alignToParent(view, child: recipeTable, top: 85, left: 20, bottom: 49, right: 20)
        
    }
    
}

/// TableViewDataSource methods.
extension RecipeVC: UITableViewDataSource {
    
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Value1, reuseIdentifier: "flavorCell")
        
        // Unpack message from Firebase DataSnapshot
        let flavorSnap: FIRDataSnapshot! = flavors[indexPath.row]
        let flavor = flavorSnap.value as! Dictionary<String, String>
        
        cell.textLabel?.text = flavor["flavorName"]!
        cell.detailTextLabel?.text = flavor["flavorPct"]! + "%"
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension RecipeVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
}
