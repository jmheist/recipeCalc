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
import GoogleMobileAds

class RecipeVC: UIViewController, GADBannerViewDelegate {
    
    var myRecipe: Bool = false
    var recipe: Recipe!
    let flavorMgr: FlavorManager = FlavorManager()
    var _refHandle: FIRDatabaseHandle!
    var tabBar: MixTabBar!
    
    var recipeName: L1!
    var recipeDesc: L2!
    var recipeAuthor: L3!
    
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
        prepareRecipe()
        prepareTableView()
        prepareTabBar()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
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
        view.layout(recipeInfo).top(8).left(14).right(14).height(100)
        
        recipeName = L1()
        recipeDesc = L2()
        recipeAuthor = L3()
        
        recipeName.text = recipe.name
        recipeName.textAlignment = .Center
        recipeInfo.layout(recipeName).top(0).left(0).right(0)
        
        recipeAuthor.textAlignment = .Center
        recipeInfo.layout(recipeAuthor).top(30).left(0).right(0)
        
        recipeDesc.text = recipe.desc
        recipeDesc.font = RobotoFont.lightWithSize(16)
        recipeDesc.textAlignment = .Center
        recipeDesc.numberOfLines = 2
        recipeInfo.layout(recipeDesc).top(60).left(0).right(0)
        
    }
    
    /// Prepare table
    func prepareTableView() {
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "flavorCell")
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        view.layout(flavorTable).top(180).left(14).right(14).bottom(100)
        
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
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn1]
        
    }
    
    func mixIt() {
        navigationController?.pushViewController(MixPrepVC(recipe: self.recipe), animated: true)
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        bannerAd.layer.zPosition = -1;
        view.layout(bannerAd).height(50).width(320).bottom(40).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.recipeView
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
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
