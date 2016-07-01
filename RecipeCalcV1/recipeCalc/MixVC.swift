//
//  MixVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/9/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase
import GoogleMobileAds

class MixVC: UIViewController, GADBannerViewDelegate {

    var recipe: Recipe!
    var settings: Settings!
    var mixTable: UITableView!
    var _refHandle: FIRDatabaseHandle!
    let flavorMgr: FlavorManager = FlavorManager()
    let ingredientMgr: IngredientManager = IngredientManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: Recipe, settings: Settings) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
        self.settings = settings
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        Queries.flavors.child(recipe.key).removeObserverWithHandle(_refHandle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTabBar()
        prepareTitle()
        prepareIngredients()
        prepareFlavors()
        prepareTable()
        prepareAds()
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    func prepareTabBar() {
        
        let tabBar: MixTabBar = MixTabBar()
        
        view.addSubview(tabBar)
        Layout.height(view, child: tabBar, height: 40)
        Layout.bottom(view, child: tabBar, bottom: 0)
        Layout.horizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Back", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(nil, action: #selector(back), forControlEvents: .TouchUpInside)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Done", forState: .Normal)
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(nil, action: #selector(done), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn2, btn1]
        
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func done() {
        analyticsMgr.sendRecipeMixed()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func prepareIngredients() {
        ingredientMgr.setup(self.settings)
    }
    
    func prepareFlavors() {
        _refHandle = Queries.flavors.child(recipe.key).observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            let key = snapshot.key as String
            let name = snapshot.value!["name"] as! String
            let base = snapshot.value!["base"] as! String
            let pct = snapshot.value!["pct"] as! String
            let flav = Flavor(name: name, base: base, pct: pct, key: key)
            self.ingredientMgr.addFlavor(flav)
            print("flavor added")
            self.mixTable.reloadData()
        })
    }
    
    func prepareTitle() {
        
        let title: L1 = L1()
        title.text = self.recipe.name
        title.textAlignment = .Center
        view.addSubview(title)
        Layout.top(view, child: title, top: 10)
        Layout.horizontally(view, child: title, left: 8, right: 8)
        
    }

    func prepareTable() {
        
        mixTable = UITableView()
        mixTable.registerClass(MixCell.self, forCellReuseIdentifier: "mixCell")
        mixTable.dataSource = self
        mixTable.delegate = self
        view.addSubview(mixTable)
        Layout.edges(view, child: mixTable, top: 60, left: 5, bottom: 90, right: 5)
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        bannerAd.layer.zPosition = -1;
        view.layout(bannerAd).height(50).width(320).bottom(40).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.AdMobAdUnitID
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
}



/// TableViewDataSource methods.
extension MixVC: UITableViewDataSource {
    
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ingredientMgr.ingredients.count+1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row > 0 {
            let cell: MixCell = MixCell(style: .Default, reuseIdentifier: "mixCell")
            let ing = ingredientMgr.ingredients[(indexPath.row-1)]
            
            cell.name.text = ing.name
            cell.grams.text = ing.grams
            cell.ml.text = ing.ml
            cell.pct.text = ing.pct
            
            return cell
        } else {
            let cell: MixCell = MixCell(style: .Default, reuseIdentifier: "mixCell")
            
            cell.name.text = "Ingredient"
            cell.grams.text = "grams"
            cell.ml.text = "ml"
            cell.pct.text = "%"
            
            return cell
        }
    }
}

/// UITableViewDelegate methods.
extension MixVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }
    
}
