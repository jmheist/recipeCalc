//
//  ProfileVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/1/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

import Firebase
import FBSDKCoreKit
import GoogleMobileAds
import Material
import ImagePicker
import Refresher
import MRConfirmationAlertView
import Photos

class ProfileVC: UIViewController, GADBannerViewDelegate, ImagePickerDelegate, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    class statHeader: L3 {
        override func prepareView() {
            font = RobotoFont.boldWithSize(12)
            textAlignment = .Center
        }
    }
    
    class stat: L3 {
        override func prepareView() {
            font = RobotoFont.regularWithSize(12)
            textAlignment = .Center
        }
    }
    
    /// NavigationBar title label.
    private var titleLabel: UILabel!
    
    var profilePicView: UIImageView!
    var profileImage: UIImage!
    
    var favTable: UITableView!
    var recTable: UITableView!
    
    var favs: [Recipe] = []
    let favMgr: FavoriteManager = FavoriteManager()
    
    var recipes: [Recipe] = []
    let recMgr: RecipeManager = RecipeManager()
    
    var user: String = ""
    
    var tabBar: TabBar!
    
    var imagePicker: ImagePickerController = ImagePickerController()
    
    var bio: L2!
    
    var username: L2!
    var joined: L3!
    var recipesCount: stat!
    var starAvg: stat!
    var favCount: stat!
    var location: L3!
    
    var userToLoad: User!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(user: String) {
        self.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Stops the tableView contentInsets from being automatically adjusted.
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavButtons()
        prepareProfile()
        prepareTables()
        prepareTabBar()
        prepareAds()
        prepareImagePicker()
        prepareRefresher()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.user != "" {
            hidesBottomBarWhenPushed = true
        }
        prepareData()
        prepareNavigationItem()
        prepareNavButtons()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Profile"
    }
    
    func prepareNavButtons() {
        if self.user == "" {
            let updateButton = UIBarButtonItem(title: "Update", style: .Plain, target: self, action: #selector(didTapUpdateProfile))
            navigationItem.leftBarButtonItems = [updateButton]
            let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(signOut))
            navigationItem.rightBarButtonItems = [logoutButton]
        }
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Profile"
        tabBarItem.image = UIImage(named: "contacts")
    }
    
    func prepareData() {
        
        if self.user != "" {
            UserMgr.getUserByKey(self.user, completionHandler: { (fbUser) in
                self.userToLoad = fbUser
                self.loadData()
            })
        } else {
            userToLoad = AppState.sharedInstance.signedInUser
            loadData()
        }
    }
    
    func loadData() {
        
        username.text = userToLoad.username
        location.text = userToLoad.location
        joined.text = ("Joined: " + userToLoad.joined!)
        
        favMgr.getUserFavs(userToLoad.uid!) { (recipes) in
            
            self.favs = recipes
            self.favTable.reloadData()
        }
        
        if user == "" {
            recipeMgr.getUserRecipes(userToLoad.uid!, sort: "stars", completionHandler: { (recipes) in
                self.recipes = recipes
                self.recTable.reloadData()
            })
        } else {
            recipeMgr.getUserPublishedRecipes(userToLoad.uid!, sort: "stars", completionHandler: { (recipes) in
                self.recipes = recipes
                self.recTable.reloadData()
            })
        }
        
        storageMgr.getProfilePic(userToLoad.uid!) { (image) in
            self.profileImage = image
            self.profilePicView.backgroundColor = colors.dark
            self.profilePicView.image = self.profileImage
        }
        
        loadUserStats()
    }
    
    func loadUserStats() {
        
        let userToLoad = self.user != "" ? self.user : AppState.sharedInstance.signedInUser.uid!
        
        UserMgr.loadUserStats(userToLoad) { (publishedRecipeCount, starAvg, favCount) in
            self.recipesCount.text = String(publishedRecipeCount)
            self.starAvg.text = String(starAvg)
            self.favCount.text = String(favCount)
        }
        
        if self.user != "" {
            UserMgr.getUserByKey(self.user, completionHandler: { (fbUser) in
                self.bio.text = fbUser.bio
                self.location.text = fbUser.location
            })
        } else {
            bio.text = AppState.sharedInstance.signedInUser.bio == "" ? "" : AppState.sharedInstance.signedInUser.bio
            location.text = AppState.sharedInstance.signedInUser.location!
        }
    }
    
    func prepareProfile() {
        
        let profileView: MaterialView = MaterialView()
        view.layout(profileView).left(8).right(8).top(8).height(175)
        
        self.profilePicView = UIImageView()
        self.profilePicView.layer.cornerRadius = 40
        self.profilePicView.clipsToBounds = true
        self.profilePicView.backgroundColor = colors.background
        
        if self.user == "" {
            let pictap = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
            profilePicView.addGestureRecognizer(pictap)
            profilePicView.userInteractionEnabled = true
        }
        
        profileView.layout(self.profilePicView).top(0).left(0).height(80).width(80)
        
        username = L2()
        profileView.layout(username).left(0).top(88).width(300)
        
        // max length for bio should be around 75-80 characters
        bio = L2()
        bio.numberOfLines = 2
        bio.font = RobotoFont.lightWithSize(14)
        profileView.layout(bio).top(114).left(0).width(250)
        
        
        // start on recipe stats
        
        let profileStatsView: MaterialView = MaterialView()
        profileView.backgroundColor = MaterialColor.clear
        profileView.layout(profileStatsView).top(0).right(14).height(55).width(200)

        
        let recipesLabel: statHeader = statHeader()
        recipesLabel.text = "Published"
        profileStatsView.addSubview(recipesLabel)
        
        let starsLabel: statHeader = statHeader()
        starsLabel.text = "Avg Stars"
        profileStatsView.addSubview(starsLabel)
        
        let favsLabel: statHeader = statHeader()
        favsLabel.text = " Total Favs"
        profileStatsView.addSubview(favsLabel)
        
        recipesCount = stat()
        recipesCount.text = "0"
        profileStatsView.addSubview(recipesCount)
        
        starAvg = stat()
        starAvg.text = "0"
        profileStatsView.addSubview(starAvg)
        
        favCount = stat()
        favCount.text = "0"
        profileStatsView.addSubview(favCount)
        
        let labels = [recipesLabel, starsLabel, favsLabel, recipesCount, starAvg, favCount]
        var rowOffset = 0
        var columnOffset = 0
        
        for label in labels {
            label.grid.rows = 6
            label.grid.columns = 4
            if columnOffset < 12 {
                label.grid.offset.columns = columnOffset
                label.grid.offset.rows = rowOffset
                columnOffset += 4
            } else {
                rowOffset = 6
                columnOffset = 0
                label.grid.offset.columns = columnOffset
                label.grid.offset.rows = rowOffset
                columnOffset += 4
            }
        }
        
        profileStatsView.grid.spacing = 1
        profileStatsView.grid.axis.direction = .None
        profileStatsView.grid.contentInsetPreset = .Square2
        profileStatsView.grid.views = labels
        
        // END RECIPE STATS
        
        let infoView: MaterialView = MaterialView()
        infoView.backgroundColor = MaterialColor.clear
        profileView.layout(infoView).top(50).width(200).right(14).height(28)
        
        location = L3()
        location.textLayer.pointSize = 12
        location.textAlignment = .Center
        infoView.layout(location).top(0).left(0).right(0).height(14)
        
        joined = L3()
        joined.textLayer.pointSize = 12
        joined.textAlignment = .Center
        infoView.layout(joined).top(14).left(0).right(0).height(14)

        
    }
    
    func prepareTables() {
        recTable = UITableView()
        favTable = UITableView()
        
        registerFavClass()
        registerRecClass()
        
        recTable.delegate = self
        recTable.dataSource = self
        favTable.delegate = self
        favTable.dataSource = self
        
        favTable.rowHeight = UITableViewAutomaticDimension
        favTable.estimatedRowHeight = 60
        recTable.rowHeight = UITableViewAutomaticDimension
        recTable.estimatedRowHeight = 40
        
        let tableView: MaterialView = MaterialView()
        view.layout(tableView).top(220).left().right().bottom(self.user != "" ? 50 : 99)
        
        favTable.hidden = true
        
        tableView.layout(favTable).edges()
        tableView.layout(recTable).edges()
        
    }
    
    func showFavTable() {
        recTable.hidden = true
        favTable.hidden = false
        favTable.reloadData()
    }
    
    func showRecTable() {
        favTable.hidden = true
        recTable.hidden = false
        recTable.reloadData()
    }
    
    func prepareTabBar() {
        tabBar = TabBar()
        view.layout(tabBar).top(175).left(0).right(0).height(40)
        tabBar.backgroundColor = colors.background
        tabBar.line.backgroundColor = colors.medium
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Recipes", forState: .Normal)
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(self, action: #selector(showRecTable), forControlEvents: .TouchUpInside)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Favorites", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(self, action: #selector(showFavTable), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn1, btn2]
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        bannerAd.layer.zPosition = -1;
        view.layout(bannerAd).height(50).width(320).bottom(self.user != "" ? 0 : 50).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.profile
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
    }
    
    func prepareImagePicker() {
        imagePicker.delegate = self
        imagePicker.imageLimit = 1
    }
    
    func showImagePicker() {
        print("show image picker")
        imagePicker.galleryView.selectedStack.resetAssets(imagePicker.stack.assets)
        imagePicker.showGalleryView()
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func wrapperDidPress(images: [UIImage]) {
        print("wrapper")
        imagePicker.showGalleryView()
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        print("done")
        let selectedImage = imagePicker.stack.assets[0]
        print(selectedImage)
        
        storageMgr.saveProfileImage(selectedImage, uid: AppState.sharedInstance.signedInUser.uid!) { (image, imageFound) in
            if imageFound {
                self.profileImage = image
            } else {
                self.profileImage = MaterialIcon.image
            }
            analyticsMgr.sendProfilePicUpdated()
            self.profilePicView.image = self.profileImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancelButtonDidPress() {
        print("cancel")
    }
    
    func didTapUpdateProfile() {
        navigationController?.pushViewController(UpdateProfileVC(), animated: true)
    }
    
    func signOut() {
        print("did tap sign out")
        alertMgr.alertWithOptions("Signout", message: "Are you sure you want\nto log out?", cancelBtn: "Cancel", conFirmBtn: "Logout") { (confirmed) in
            if confirmed {
                UserMgr.signOut(self)
            }
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = ""
            textView.textColor = UIColor.darkGrayColor()
        }
    }
    
    func prepareRefresher() {
        let pacmanAnimator = PacmanAnimator(frame: CGRectMake(0, 0, 80, 80))
        let pacmanAnimator2 = PacmanAnimator(frame: CGRectMake(0, 0, 80, 80))
        recTable.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                print("refreshing")
                self.updateRecTable()
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.recTable.stopPullToRefresh()
                }
            }
        }, withAnimator: pacmanAnimator)
        favTable.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                print("refreshing")
                self.updateFavTable()
                sleep(1)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.favTable.stopPullToRefresh()
                }
            }
        }, withAnimator: pacmanAnimator2)
    }
    
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === self.favTable {
            return self.favs.count
        } else if tableView === self.recTable {
            return self.recipes.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView === self.favTable {
            
            let cell: PublicRecipeCell = PublicRecipeCell(style: .Default, reuseIdentifier: "favRecipeCell")
            
            let recipe = favs[indexPath.row]
            
            cell.starRatingView.value = recipe.stars
            cell.starRatingCount.text = "(\(recipe.starsCount))"
            cell.heartCount.text = "\(recipe.favCount)"
            cell.selectionStyle = .None
            cell.recipeName.text = recipe.name
            cell.creator.text = recipe.author
            cell.recipeID = recipe.key
            
            storageMgr.getProfilePic(recipe.authorId, completionHandler: { (image) in
                cell.profilePicView.backgroundColor = colors.dark
                cell.profilePicView.image = image
            })
            
            return cell
            
        } else if tableView === self.recTable {
            
            let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "recipeCell")
            
            let recipe = self.recipes[indexPath.row]
            
            if recipe.published == "true" {
                cell.starRatingView.value = recipe.stars
                cell.starRatingCount.text = "\(recipe.starsCount)"
                cell.heartCount.text = "\(recipe.favCount)"
            } else {
                cell.ratingContainer.hidden = true
                cell.publishedText.hidden = false
            }
            
            cell.selectionStyle = .None
            cell.recipeName.text = recipe.name
            cell.recipeID = recipe.key
            
            return cell
        } else {
            print("no table cell")
            let cell: MyRecipeCell = MyRecipeCell(style: .Default, reuseIdentifier: "recipeCell")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.recTable {
            if(editingStyle == UITableViewCellEditingStyle.Delete){
                alertMgr.alertWithOptions("Delete Recipe", message: "Are you sure you want\nto delete this recipe?", cancelBtn: "Cancel", conFirmBtn: "Delete", completionHanlder: { (confirmed) in
                    if confirmed {
                        let key = self.recipes[indexPath.row].key
                        recipeMgr.deleteRecipe(key, completionHandler: { (recs) in
                            self.recipes = recs
                            self.recTable.reloadData()
                        })
                    }
                    else {
                        tableView.setEditing(false, animated: true)
                    }
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if tableView == self.favTable {
            return false
        } else {
            return true
        }
    }
    
    func registerFavClass() {
        recTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "favRecipeCell")
    }
    
    func registerRecClass() {
        recTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "recipeCell")
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView === self.favTable {
            analyticsMgr.sendPublicRecipeViewed()
            navigationController?.pushViewController(PublicRecipeVC(recipe: favs[indexPath.row]), animated: true)
        } else if tableView === self.recTable {
            if user == "" {
                navigationController?.pushViewController(MyRecipeVC(recipe: self.recipes[indexPath.row]), animated: true)
            } else {
                analyticsMgr.sendPublicRecipeViewed()
                navigationController?.pushViewController(PublicRecipeVC(recipe: self.recipes[indexPath.row]), animated: true)
            }
        }
        
    }
    
    func updateRecTable() {
        print("updateRecTable()")
        if user == "" {
            recipeMgr.getUserRecipes(AppState.sharedInstance.signedInUser.uid!, sort: "stars", completionHandler: { (recipes) in
                self.recipes = recipes
                self.recTable.reloadData()
            })
        } else {
            recipeMgr.getPublishedRecipes("stars", completionHandler: { (recipes) in
                self.recipes = recipes
                self.recTable.reloadData()
            })
        }
    }
    
    func updateFavTable() {
        if user == "" {
            favMgr.getUserFavs(AppState.sharedInstance.signedInUser.uid!) { (recipes) in
                self.favs = recipes
                print(self.favs)
                self.favTable.reloadData()
            }
        } else {
            favMgr.getUserFavs(user) { (recipes) in
                self.favs = recipes
                self.favTable.reloadData()
            }
        }
    }
    
    
}
