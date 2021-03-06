//
//  FavListVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/30/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class FavListVC: TableVC {
    
    var favs: [Recipe] = []
    let favMgr: FavoriteManager = FavoriteManager()
    
    override func prepareView() {
        super.prepareView()
    }
    
    /// Prepare tabBarItem.
    override func prepareTabBarItem() {
        hidesBottomBarWhenPushed = true
    }
    
    /// Prepares the navigationItem.
    override func prepareNavigationItem() {
        navigationItem.title = "My Favorites"
    }
    
    override func configureDatabase() {
        favMgr.getUserFavs(AppState.sharedInstance.uid!) { (recipes) in
            self.favs = recipes
            self.recipeTable.reloadData()
        }
    }
    
    func showFavs() {
        navigationController?.presentViewController(FavListVC(), animated: true, completion: nil)
    }
    
    // UITableViewDataSource protocol methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: PublicRecipeCell = PublicRecipeCell(style: .Default, reuseIdentifier: "publicRecipeCell")
        
        let recipe = favs[indexPath.row]
        
        cell.starRatingView.value = recipe.stars
        cell.starRatingCount.text = "(\(recipe.starsCount))"
        cell.heartCount.text = "\(recipe.favCount)"
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.recipeDesc.text = recipe.desc
        cell.creator.text = recipe.author
        cell.recipeID = recipe.key
        
        return cell
    }
    
    override func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "publicRecipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(PublicRecipeVC(recipe: favs[indexPath.row]), animated: true)
    }
    
    override func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(0).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.favList
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
}
