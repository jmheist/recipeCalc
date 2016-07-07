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

class ProfileVC: UIViewController, GADBannerViewDelegate, ImagePickerDelegate {
    
    /// NavigationBar title label.
    private var titleLabel: UILabel!
    
    var profilePicView: UIImageView!
    var profileImage: UIImage!
    
    let imagePicker: ImagePickerController = ImagePickerController()
    
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
        prepareAds()
        prepareImagePicker()
    }
    
    override func viewDidAppear(animated: Bool) {
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
        
        let profileView: MaterialView = MaterialView()
        view.layout(profileView).left(8).right(8).top(8).height(400)
        
        self.profilePicView = UIImageView()
        self.profilePicView.layer.cornerRadius = 40
        self.profilePicView.clipsToBounds = true
        self.profilePicView.backgroundColor = colors.background
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
        profileView.addGestureRecognizer(tap)
        profileView.userInteractionEnabled = true
        profileView.layout(self.profilePicView).top(0).left(0).height(80).width(80)
        
        storageMgr.getProfilePic(AppState.sharedInstance.uid!) { (image, imageFound) in
            if imageFound {
                self.profileImage = image
            } else {
                self.profileImage = MaterialIcon.image
            }
            
            self.profilePicView.image = self.profileImage
        }
        
        let username: L2 = L2()
        username.text = AppState.sharedInstance.displayName
        profileView.layout(username).left(0).top(88).width(300)
        
        let joined: L3 = L3()
        joined.text = "Joined: "+AppState.sharedInstance.joined!
        joined.textAlignment = .Right
        profileView.layout(joined).top(88).right(0).width(150)
        
        // max length for bio should be around 75-80 characters
        let bio: L2 = L2()
        bio.text = "This is my bio, just a blip about me. This is my bio, just a blip about me."
        bio.numberOfLines = 2
        bio.font = RobotoFont.lightWithSize(14)
        profileView.layout(bio).top(114).left(0).width(250)
        
        
        // start on recipe stats
        
        
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        bannerAd.layer.zPosition = -1;
        view.layout(bannerAd).height(50).width(320).bottom(50).centerHorizontally()
        
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
        
        storageMgr.saveProfileImage(selectedImage, uid: AppState.sharedInstance.uid!) { (image, imageFound) in
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
        UserMgr.signOut(self)
    }

}
