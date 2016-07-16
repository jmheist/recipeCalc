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
import GoogleMobileAds

class TableVC: UIViewController, GADBannerViewDelegate, UITableViewDelegate {
    
    // VARS
    var recipeTable: UITableView!
    var recipes: [Recipe] = []

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
        prepareTableView()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recipeTable.reloadData()
    }
    
    func configureDatabase() {
        recipeMgr.getUserRecipes(AppState.sharedInstance.signedInUser.uid!, sort: "stars", completionHandler: { (recs) in
            self.recipes = recs
            self.recipeTable.reloadData()
        })
        
    }
    
    /// General preparation statements.
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    func prepareTabBarItem() {
        tabBarItem.title = "My Recipes"
        tabBarItem.image = MaterialIcon.menu
    }
    
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
        recipeTable.estimatedRowHeight = 50
        recipeTable.rowHeight = UITableViewAutomaticDimension
        
        view.layout(recipeTable).top(0).left(0).right(0).bottom(100)
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(50).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.recipeList
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
    func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "recipeCell")
    }
}

/// UITableViewDelegate methods.
extension TableVC: UITableViewDataSource {
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "myRecipeCell")
        
        let recipe = self.recipes[indexPath.row]
        
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.recipeID = recipe.key
        
        return cell
    }
}
