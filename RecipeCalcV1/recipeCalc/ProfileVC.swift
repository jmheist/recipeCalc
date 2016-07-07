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

class ProfileVC: UIViewController, GADBannerViewDelegate, ImagePickerDelegate, UITextViewDelegate {
    
    /// NavigationBar title label.
    private var titleLabel: UILabel!
    
    var profilePicView: UIImageView!
    var profileImage: UIImage!
    
    let imagePicker: ImagePickerController = ImagePickerController()
    
    var bio: L2!
    
    
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
        let pictap = UITapGestureRecognizer(target: self, action: #selector(self.showImagePicker))
        profilePicView.addGestureRecognizer(pictap)
        profilePicView.userInteractionEnabled = true
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
        bio = L2()
        bio.text = AppState.sharedInstance.bio == "" ? "Add a Bio" : AppState.sharedInstance.bio
//        let biotap = UITapGestureRecognizer(target: self, action: #selector(self.showBioAlert(_:)))
//        bio.addGestureRecognizer(biotap)
//        bio.userInteractionEnabled = true
        bio.numberOfLines = 2
        bio.font = RobotoFont.lightWithSize(14)
        profileView.layout(bio).top(114).left(0).width(250)
        
        
        // start on recipe stats
        
        let profileStatsView: MaterialView = MaterialView()
        profileView.layout(profileStatsView).top(0).right(0).height(70).width(250)
        
        class statHeader: L3 {
            override func prepareView() {
                font = RobotoFont.boldWithSize(14)
                textAlignment = .Center
            }
        }
        
        class stat: L3 {
            override func prepareView() {
                font = RobotoFont.regularWithSize(16)
                textAlignment = .Center
            }
        }
        
        let recipesLabel: statHeader = statHeader()
        recipesLabel.text = "Recipes"
        profileStatsView.addSubview(recipesLabel)
        
        let starsLabel: statHeader = statHeader()
        starsLabel.text = "Stars"
        profileStatsView.addSubview(starsLabel)
        
        let favsLabel: statHeader = statHeader()
        favsLabel.text = "Favs"
        profileStatsView.addSubview(favsLabel)
        
        let recipes: stat = stat()
        recipes.text = "20"
        profileStatsView.addSubview(recipes)
        
        let stars: stat = stat()
        stars.text = "4.2"
        profileStatsView.addSubview(stars)
        
        let favs: stat = stat()
        favs.text = "197"
        profileStatsView.addSubview(favs)
        
        let labels = [recipesLabel, starsLabel, favsLabel, recipes, stars, favs]
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
    
//    func showBioAlert(sender: AnyObject) {
//        let alertController = UIAlertController(title: "Update Your Bio \n\n\n\n\n\n\n", message: "", preferredStyle: .Alert)
//        
//        let rect        = CGRectMake(15, 50, 240, 150.0)
//        let textView    = UITextView(frame: rect)
//        
//        textView.font               = UIFont(name: "Helvetica", size: 15)
//        textView.textColor          = UIColor.lightGrayColor()
//        textView.backgroundColor    = UIColor.whiteColor()
//        textView.layer.borderColor  = UIColor.lightGrayColor().CGColor
//        textView.layer.borderWidth  = 1.0
//        textView.text               = "Enter message here"
//        textView.delegate           = self
//        
//        alertController.view.addSubview(textView)
//        
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        let action = UIAlertAction(title: "Ok", style: .Default, handler: { action in
//            
//            let msg = (textView.textColor == UIColor.lightGrayColor()) ? "" : textView.text
//            
//            AppState.sharedInstance.bio = msg
//            UserMgr.sendDataToFirebase(AppState.sharedInstance.uid!, key: "bio", value: msg)
//            self.bio.text = AppState.sharedInstance.bio == "" ? "Add a Bio" : AppState.sharedInstance.bio
//            
//        })
//        alertController.addAction(cancel)
//        alertController.addAction(action)
//        
//        self.presentViewController(alertController, animated: true, completion: {})
//        
//    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = ""
            textView.textColor = UIColor.darkGrayColor()
        }
    }
    
}
