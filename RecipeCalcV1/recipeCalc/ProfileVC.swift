//
//  ProfileVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/1/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase
import FBSDKCoreKit
import GoogleMobileAds

class ProfileVC: UIViewController, GADBannerViewDelegate {
    
    /// NavigationBar title label.
    private var titleLabel: UILabel!
    
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
        prepareNavigationItem()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
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
        let updateButton = UIBarButtonItem(title: "Update", style: .Plain, target: self, action: #selector(didTapUpdateProfile))
        navigationItem.leftBarButtonItems = [updateButton]
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Settings"
        tabBarItem.image = MaterialIcon.settings
    }
    
    func prepareProfile() {
        
        let username: L2 = L2()
        username.text = AppState.sharedInstance.displayName
        
        let email: L2 = L2()
        email.text = AppState.sharedInstance.email
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        bannerAd.layer.zPosition = -1;
        view.layout(bannerAd).height(50).width(320).bottom(50).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.profile
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
    func didTapUpdateProfile() {
        navigationController?.pushViewController(UpdateProfileVC(), animated: true)
    }
    
    func signOut() {
        UserMgr.signOut(self)
    }    
}
