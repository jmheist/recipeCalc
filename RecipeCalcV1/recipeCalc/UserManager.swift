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
    
    var username: String
    var email: String
    var profileImage: String
    var joined: String?=""
    var bio: String?=""
    
//    func fb() -> AnyObject {
//        var user = [String:AnyObject]()
//        user["username"] = self.username
//        user["email"] = self.email
//        user["profileImage"] = self.profileImage
//        return user
//    }
    
}

let UserMgr: UserManager = UserManager()

class UserManager: NSObject {
    
    func sendDataToFirebase(userUid: String, key: String, value: String) {
        Queries.users.child(userUid).child(key).setValue(value)
    }
    
    func getUserByKey(key: String, completionHandler:(User)->()) {
        Queries.users.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let user = User(
                username: snapshot.value!["username"] as? String ?? "",
                email: snapshot.value!["email"] as? String ?? "",
                profileImage: snapshot.value!["profileImage"] as? String ?? "",
                joined: snapshot.value!["joined"] as? String ?? "",
                bio: snapshot.value!["bio"] as? String ?? ""
            )
            completionHandler(user)
        })
    }
    
    func getUserByUsername(username: String, completionHandler:(User)->()) {
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let name = snap.value!["username"] as! String
                if name.lowercaseString == username.lowercaseString {
                    let user = User(
                        username: name,
                        email: snap.value!["email"] as! String,
                        profileImage: snapshot.value!["profileImage"] as? String ?? "",
                        joined: snapshot.value!["joined"] as? String ?? "",
                        bio: snapshot.value!["bio"] as? String ?? ""
                    )
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
                    let user = User(
                        username: snap.value!["username"] as! String,
                        email: emailval,
                        profileImage: snapshot.value!["profileImage"] as? String ?? "",
                        joined: snapshot.value!["joined"] as? String ?? "",
                        bio: snapshot.value!["bio"] as? String ?? ""
                    )
                    completionHandler(user)
                }
            }
        })
    }
    
    func signedIn(user: FIRUser?, provider: Bool=false, sender: UIViewController) {
        analyticsMgr.sendLoginEvent()
        AppState.sharedInstance.uid = user?.uid
        
        func finish() {
            print(
                "Username: \(AppState.sharedInstance.displayName), \n",
                " Email: \(AppState.sharedInstance.email), \n",
                " uid: \(AppState.sharedInstance.uid), \n",
                " photoUrl: \(AppState.sharedInstance.profileImage)"
            )
            
            UserMgr.sendDataToFirebase((user?.uid)!, key: "username", value: AppState.sharedInstance.displayName!)
            UserMgr.sendDataToFirebase((user?.uid)!, key: "email", value: AppState.sharedInstance.email!)
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
            loadApp(sender)
        }
        
        UserMgr.getUserByKey(AppState.sharedInstance.uid!) { (firebaseUser) in
            
            if firebaseUser.username != "" {
                print("user already in DB")
                AppState.sharedInstance.displayName = firebaseUser.username
                AppState.sharedInstance.email = firebaseUser.email
                AppState.sharedInstance.profileImage = firebaseUser.profileImage
                AppState.sharedInstance.joined = firebaseUser.joined
                AppState.sharedInstance.bio = firebaseUser.bio
                AppState.sharedInstance.signedIn = true
                finish()
            } else {
                print("user not in db yet")
                let now = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                let convertedDate = dateFormatter.stringFromDate(now)
                UserMgr.sendDataToFirebase((user?.uid)!, key: "joined", value: convertedDate)
                AppState.sharedInstance.joined = convertedDate
                if provider {
                    for profile in user!.providerData {
                        //let providerID = profile.providerID
                        print("providerId: \(profile.providerID)")
                        AppState.sharedInstance.displayName = profile.displayName
                        AppState.sharedInstance.email = profile.email
                        AppState.sharedInstance.signedIn = true
                        
                        storageMgr.storeFBImage(user!, completionHandler: { (profileImageUrl) in
                            AppState.sharedInstance.profileImage = profileImageUrl
                            UserMgr.sendDataToFirebase((user?.uid)!, key: "profileImage", value: AppState.sharedInstance.profileImage!)
                            finish()
                        })
                    }
                } else {
                    AppState.sharedInstance.displayName = user?.displayName ?? user?.email
                    AppState.sharedInstance.email = user?.email
                    AppState.sharedInstance.signedIn = true
                    finish()
                }
            }
        }
    }
    
    func signOut(sender: UIViewController) {
        FBSDKAccessToken.setCurrentAccessToken(nil)
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            Queries.myRecipes.child(AppState.sharedInstance.uid!).removeAllObservers()
            AppState.sharedInstance.signedIn = false
            AppState.sharedInstance.uid = nil
            AppState.sharedInstance.recipe = nil
            analyticsMgr.sendLogoutEvent()
            print("signed out")
            myRecipeMgr.reset()
            publicRecipeMgr.reset()
            let vc = AppLandingVC()
            sender.presentViewController(vc, animated: false, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
    func loadApp(sender: UIViewController) {
        let localRecipeList: AppNav = AppNav(rootViewController: LocalRecipeListVC())
        let createRecipeViewController: AppNav = AppNav(rootViewController: CreateRecipeViewController())
        let discoveryViewController: AppNav = AppNav(rootViewController: DiscoveryViewController())
        let profileVC: AppNav = AppNav(rootViewController: ProfileVC())
        
        let bottomNavigationController: BottomNav = BottomNav()
        bottomNavigationController.viewControllers = [localRecipeList, createRecipeViewController, discoveryViewController, profileVC]
        bottomNavigationController.selectedIndex = 0
        sender.presentViewController(bottomNavigationController, animated: true, completion: nil)
    }
    
    func loadUserStats(uid: String, completionHandler:(publishedRecipeCount: Int, starAvg: Double, favCount: Int)->()) {
        var published = 0
        var stars = 0.0
        var favs = 0
        
        recipeManager.getUserPublishedRecipes(uid) { (recipes) in
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
