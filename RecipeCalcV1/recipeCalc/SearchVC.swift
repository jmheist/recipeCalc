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
    var containerView: UIView!
    
    let searchMgr: SearchManager = SearchManager()
    var searchResults = [Recipe]()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTableView()
        prepareContainerView()
        prepareSearchBar()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
        //check if user is logged in
        if AppState.sharedInstance.signedIn {
            // print("User is logged in")
        } else {
            print("User is not logged in yet, should load loginVC")
            let vc = RegisterViewController()
            self.presentViewController(vc, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.recipeTable.reloadData()
    }
    
    /// General preparation statements.
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the containerView.
    private func prepareContainerView() {
        containerView = UIView()
        view.layout(containerView).top(16).left(0).right(0).height(50)
    }
    
    /// Prepares the toolbar
    private func prepareSearchBar() {
        searchBar = SearchBar()
        containerView.addSubview(searchBar)
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
    
    func search(textfield: UITextField) {
        searchMgr.search(textfield.text!, completionHandler: { (recipes:[Recipe]) in
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(0).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.AdMobAdUnitID
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
    /// Prepare table
    func prepareTableView() {
        
        recipeTable = UITableView()
        registerMyClass()
        recipeTable.dataSource = self
        recipeTable.delegate = self
        
        view.layout(recipeTable).top(65).left(0).right(0).bottom(0)
        
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
        cell.recipeName.font = RobotoFont.regular
        
        cell.recipeDesc.text = recipe.desc
        cell.recipeDesc.font = RobotoFont.regular
        cell.recipeDesc.textColor = MaterialColor.grey.darken1
        
        cell.creator.text = recipe.author
        cell.creator.font = RobotoFont.regular
        cell.creator.textColor = MaterialColor.grey.darken1
        
        cell.recipeID = recipe.key
        
        return cell
    }
    
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.pushViewController(PublicRecipeVC(recipe: searchResults[indexPath.row]), animated: true)
    }
    
}