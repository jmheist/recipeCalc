//
//  UserManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/20/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

struct User {
    
    var uid: String?=""
    var username: String?=""
    var email: String?=""
    var profileImage: String?=""
    var joined: String?=""
    var bio: String?=""
    var location: String?=""
    
    init(uid: String?="", username: String?="", email: String?="", profileImage: String?="", joined: String?="", bio: String?="", location: String?="") {
        self.uid = uid
        self.username = username
        self.email = email
        self.profileImage = profileImage
        self.joined = joined
        self.bio = bio
        self.location = location
    }
    
}

let UserMgr: UserManager = UserManager()

class UserManager: NSObject {
    
    func sendDataToFirebase(userUid: String, key: String, value: String) {
        Queries.users.child(userUid).child(key).setValue(value)
    }
    
    func sendNewUserInfo(uid: String, username: String?=nil, bio: String?=nil, location: String?=nil, completionHandler:()->()) {
        
        if (username != nil) {
            sendDataToFirebase(uid, key: "username", value: username!)
            // update the user name in the auth db
            if let user = FIRAuth.auth()?.currentUser {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                changeRequest.commitChangesWithCompletion(){ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        if bio != nil {
            sendDataToFirebase(uid, key: "bio", value: bio!)
        }
        
        if location != nil {
            sendDataToFirebase(uid, key: "location", value: location!)
        }
        
        getUserByKey(uid) { (user) in
            AppState.sharedInstance.signedInUser = user
            completionHandler()
        }
    }
    
    func receiveUserFromFB(snapshot: FIRDataSnapshot) -> User {
        let user = User(
            uid: snapshot.key,
            username: snapshot.value!["username"] as? String ?? "",
            email: snapshot.value!["email"] as? String ?? "",
            profileImage: snapshot.value!["profileImage"] as? String ?? "",
            joined: snapshot.value!["joined"] as? String ?? "",
            bio: snapshot.value!["bio"] as? String ?? "",
            location: snapshot.value!["location"] as? String ?? ""
        )
        return user;
    }
    
    func getUserByKey(key: String, completionHandler:(User)->()) {
        Queries.users.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let user = self.receiveUserFromFB(snapshot)
            completionHandler(user)
        })
    }
    
    func getUserByUsername(username: String, completionHandler:(User)->()) {
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let name = snap.value!["username"] as! String
                if name.lowercaseString == username.lowercaseString {
                    let user = self.receiveUserFromFB(snap)
                    completionHandler(user)
                }
            }
        })
    }
    
    func getUserByEmail(email: String, completionHandler:(User)->()) {
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let emailval = snap.value!["email"] as! String
                if emailval.lowercaseString == email.lowercaseString {
                    let user = self.receiveUserFromFB(snap)
                    completionHandler(user)
                }
            }
        })
    }
    
    func signedIn(user: FIRUser?, provider: Bool=false, completionHandler:(UIViewController)->()) {
        
        analyticsMgr.sendLoginEvent()
        AppState.sharedInstance.signedInUser.uid = user?.uid
        
        func finish(newUser: Bool=false) {
            print(
                "Username: \(AppState.sharedInstance.signedInUser.username), \n",
                " Email: \(AppState.sharedInstance.signedInUser.email), \n",
                " uid: \(AppState.sharedInstance.signedInUser.uid), \n",
                " photoUrl: \(AppState.sharedInstance.signedInUser.profileImage)"
            )
            
            UserMgr.sendDataToFirebase((user?.uid)!, key: "username", value: AppState.sharedInstance.signedInUser.username!)
            UserMgr.sendDataToFirebase((user?.uid)!, key: "email", value: AppState.sharedInstance.signedInUser.email!)
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
            if newUser {
                completionHandler(loadNewUser())
            } else {
                loadApp({ (vc) in
                    completionHandler(vc)
                })
            }
        
        }
        
        UserMgr.getUserByKey(AppState.sharedInstance.signedInUser.uid!) { (firebaseUser) in
            
            if firebaseUser.username != "" {
                print("user already in DB")
                AppState.sharedInstance.signedInUser = firebaseUser
                AppState.sharedInstance.signedIn = true
                finish(false)
            } else {
                print("user not in db yet")
                let now = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                let convertedDate = dateFormatter.stringFromDate(now)
                UserMgr.sendDataToFirebase((user?.uid)!, key: "joined", value: convertedDate)
                AppState.sharedInstance.signedInUser.joined = convertedDate
                if provider {
                    for profile in user!.providerData {
                        //let providerID = profile.providerID
                        print("providerId: \(profile.providerID)")
                        AppState.sharedInstance.signedInUser.username = profile.displayName
                        AppState.sharedInstance.signedInUser.email = profile.email
                        AppState.sharedInstance.signedIn = true
                        
                        storageMgr.storeFBImage(user!, completionHandler: { (profileImageUrl) in
                            AppState.sharedInstance.signedInUser.profileImage = profileImageUrl
                            UserMgr.sendDataToFirebase((user?.uid)!, key: "profileImage", value: AppState.sharedInstance.signedInUser.profileImage!)
                            finish(true)
                        })
                    }
                } else {
                    AppState.sharedInstance.signedInUser.username = user?.displayName ?? user?.email
                    AppState.sharedInstance.signedInUser.email = user?.email
                    AppState.sharedInstance.signedIn = true
                    finish(true)
                }
            }
        }
    }
    
    func signOut(sender: UIViewController?=nil) {
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            AppState.sharedInstance.signedInUser.uid = nil
            AppState.sharedInstance.recipe = nil
            analyticsMgr.sendLogoutEvent()
            print("signed out")
            let vc = AppLandingVC()
            if sender != nil {
                sender!.presentViewController(vc, animated: false, completion: nil)
            } else {
                currentVC()?.presentViewController(vc, animated: true, completion: nil)
            }
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
    func currentVC() -> UIViewController? {
        guard let navigationController = UIApplication.sharedApplication().keyWindow?.rootViewController as? UINavigationController else { return nil }
        return navigationController.viewControllers.last
    }
    
    func loadApp(completionHandler:(UIViewController)->()) {
        //let localRecipeList: AppNav = AppNav(rootViewController: LocalRecipeListVC())
        let createRecipeViewController: AppNav = AppNav(rootViewController: CreateRecipeViewController())
        let discoveryViewController: AppNav = AppNav(rootViewController: DiscoveryViewController())
        let profileVC: AppNav = AppNav(rootViewController: ProfileVC())
        
        let bottomNavigationController: BottomNav = BottomNav()
        bottomNavigationController.viewControllers = [discoveryViewController, createRecipeViewController, profileVC]
        bottomNavigationController.selectedIndex = 0
        completionHandler(bottomNavigationController)
    }
    
    func loadNewUser() -> UIViewController {
        let vc: NewUserInfoVC = NewUserInfoVC()
        return vc
    }
    
    func loadUserStats(uid: String, completionHandler:(publishedRecipeCount: Int, starAvg: Double, favCount: Int)->()) {
        var published = 0
        var stars = 0.0
        var favs = 0
        
        recipeMgr.getUserPublishedRecipes(uid, sort: "stars") { (recipes) in
            var starTotal = 0.0
            for rec in recipes {
                favs += rec.favCount
                published += 1
                starTotal += Double(rec.stars)
            }
            stars = starTotal == 0.0 ? 0.0 : starTotal/Double(recipes.count)
            completionHandler(publishedRecipeCount: published, starAvg: floor(stars * 100) / 100, favCount: favs)
        }
    }
}
