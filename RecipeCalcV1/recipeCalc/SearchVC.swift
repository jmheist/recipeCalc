//
//  SearchVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/22/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import GoogleMobileAds

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, TextFieldDelegate, GADBannerViewDelegate {
    
    var searchBar: SearchBar!
    var recipeTable: UITableView!
    
    let searchMgr: SearchManager = SearchManager()
    var searchResults = [Recipe]()
    var searchDidReturn = false
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("mem warning.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTableView()
        prepareSearchBar()
        prepareAds()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recipeTable.reloadData()
    }
    
    /// General preparation statements.
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the toolbar
    private func prepareSearchBar() {
        searchBar = SearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.textField.addTarget(self, action: #selector(self.search(_:)), forControlEvents: UIControlEvents.EditingChanged)
        searchBar.clearButton.addTarget(self, action: #selector(self.clearSearch), forControlEvents: .TouchUpInside)
        
        // More button.
        let image: UIImage? = MaterialIcon.cm.arrowBack
        let moreButton: IconButton = IconButton()
        moreButton.pulseColor = MaterialColor.grey.base
        moreButton.tintColor = MaterialColor.grey.darken4
        moreButton.setImage(image, forState: .Normal)
        moreButton.setImage(image, forState: .Highlighted)
        moreButton.addTarget(self, action: #selector(goBack), forControlEvents: .TouchUpInside)
        
        /*
         To lighten the status bar - add the
         "View controller-based status bar appearance = NO"
         to your info.plist file and set the following property.
         */
        searchBar.leftControls = [moreButton]
    }
    
    var debounceTimer: NSTimer?
    func search(textfield: UITextField) {
        
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(returnSearch), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(debounceTimer!, forMode: "NSDefaultRunLoopMode")
    }
    
    func returnSearch() {
        
        print("searching: \(self.searchBar.textField.text!)")
        self.searchMgr.search(self.searchBar.textField.text!, completionHandler: { (recipes:[Recipe]) in
            self.searchResults = recipes
            self.recipeTable.reloadData()
        })
    
    }
    
    func clearSearch() {
        searchMgr.reset()
        self.searchResults = []
        recipeTable.reloadData()
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(0).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.search
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
    }
    
    /// Prepare table
    func prepareTableView() {
        
        recipeTable = UITableView()
        registerMyClass()
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        view.layout(recipeTable).top(0).left(0).right(0).bottom(0)
        
    }
    
    func registerMyClass() {
        recipeTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell: PublicRecipeCell = PublicRecipeCell(style: .Default, reuseIdentifier: "searchCell")
        
        let recipe = searchResults[indexPath.row]
        
        cell.starRatingView.value = recipe.stars
        
        cell.selectionStyle = .None
        cell.recipeName.text = recipe.name
        cell.creator.text = recipe.author
        cell.recipeID = recipe.key
        
        storageMgr.getProfilePic(recipe.authorId, completionHandler: { (image) in
            cell.profilePicView.backgroundColor = colors.dark
            cell.profilePicView.image = image
        })
        
        return cell
    }
    
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select row: \(indexPath.row)")
        if searchResults[indexPath.row].authorId == AppState.sharedInstance.signedInUser.uid {
            navigationController?.pushViewController(MyRecipeVC(recipe: self.searchResults[indexPath.row]), animated: true)
        } else {
            navigationController?.pushViewController(PublicRecipeVC(recipe: self.searchResults[indexPath.row]), animated: true)
        }
    }
    
}