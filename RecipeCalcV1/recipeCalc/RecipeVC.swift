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
    let flavorMgr: FlavorManager = FlavorManager()
    var _refHandle: FIRDatabaseHandle!
    var tabBar: MixTabBar!
    
    var flavorTable: UITableView!
    
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
        prepareTabBar()
    }
    
    deinit {
        Queries.flavors.child(recipe.key).removeObserverWithHandle(_refHandle)
    }
    
    // Queries.flavors.child(recipes[indexPath.row].key)
    func prepareFlavors() {
        _refHandle = Queries.flavors.child(recipe.key).observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            let key = snapshot.key as String
            let name = snapshot.value!["name"] as! String
            let base = snapshot.value!["base"] as! String
            let pct = snapshot.value!["pct"] as! String
            let flav = Flavor(name: name, base: base, pct: pct, key: key)
            self.flavorMgr.addFlavor(flav)
            self.flavorTable.reloadData()

        })
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = recipe.name
    }
    
    func prepareRecipe() {
                
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        Layout.edges(view, child: recipeInfo, top: 0, left: 0, bottom: 49, right: 0)
        
        let recipeDesc: L2 = L2()
        
        recipeDesc.text = recipe.desc
        recipeDesc.textAlignment = .Center
        
        recipeInfo.addSubview(recipeDesc)
        
        Layout.top(recipeInfo, child: recipeDesc, top: 25)
        Layout.horizontally(recipeInfo, child: recipeDesc)
        
    }
    
    /// Prepare table
    func prepareTableView() {
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "flavorCell")
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        view.addSubview(flavorTable)
        Layout.edges(view, child: flavorTable, top: 100, left: 20, bottom: 49, right: 20)
        
    }
    
    func prepareTabBar() {
        
        let tabBar = MixTabBar()
        
        view.addSubview(tabBar)
        Layout.height(view, child: tabBar, height: 40)
        Layout.bottom(view, child: tabBar, bottom: 0)
        Layout.horizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Mix", forState: .Normal)
        btn1.setTitleColor(colors.textDark, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn1]
        
    }
    
    func mixIt() {
        navigationController?.pushViewController(MixPrepVC(recipe: self.recipe), animated: true)
    }
    
}

/// TableViewDataSource methods.
extension RecipeVC: UITableViewDataSource {
    
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavorMgr.flavors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Value1, reuseIdentifier: "flavorCell")
        
        let flavor = flavorMgr.flavors[indexPath.row]
        
        cell.textLabel?.text = flavor.name
        cell.detailTextLabel?.text = "\(flavor.pct)% \(flavor.base)"
        return cell
    }
}

/// UITableViewDelegate methods.
extension RecipeVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
    
}
