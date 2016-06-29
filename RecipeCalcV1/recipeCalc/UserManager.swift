//
//  UserManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/20/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

struct User {
    
    var username: String
    var email: String
    
    func fb() -> AnyObject {
        var user = [String:AnyObject]()
        user["username"] = self.username
        user["email"] = self.email
        return user
    }
    
}

let UserMgr: UserManager = UserManager()

class UserManager: NSObject {
    
    func sendToFirebase(user: User, uid: String) {
        Queries.users.child(uid).setValue(user.fb())
    }
    
    func getUserByKey(key: String, completionHandler:(User)->()) {
        Queries.users.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let user = User(
                username: snapshot.value!["username"] as! String,
                email: snapshot.value!["email"] as! String
            )
            completionHandler(user)
        })
    }
    
    func getUserByUsername(username: String, completionHandler:(User)->()) {
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            print("querying by username")
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let name = snap.value!["username"] as! String
                if name.lowercaseString == username.lowercaseString {
                    let user = User(
                        username: name,
                        email: snap.value!["email"] as! String
                    )
                    completionHandler(user)
                }
            }
        })
    }
    
    func getUserByEmail(email: String, completionHandler:(User)->()) {
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            print("querying by email")
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                let emailval = snap.value!["email"] as! String
                print(emailval)
                if emailval.lowercaseString == email.lowercaseString {
                    let user = User(
                        username: snap.value!["username"] as! String,
                        email: emailval
                    )
                    completionHandler(user)
                }
            }
        })
    }
    
    func signedIn(user: FIRUser?, provider: Bool=false, sender: UIViewController) {
        MeasurementHelper.sendLoginEvent()
        AppState.sharedInstance.uid = user?.uid
        if provider {
            for profile in user!.providerData {
                //let providerID = profile.providerID
                print("providerId: \(profile.providerID)")
                AppState.sharedInstance.displayName = profile.displayName
                AppState.sharedInstance.email = profile.email
                AppState.sharedInstance.photoUrl = profile.photoURL
                AppState.sharedInstance.signedIn = true
            }
        } else {
            AppState.sharedInstance.displayName = user?.displayName ?? user?.email
            AppState.sharedInstance.photoUrl = user?.photoURL
            AppState.sharedInstance.email = user?.email
            AppState.sharedInstance.signedIn = true
            print(user, user?.email, user?.displayName)
        }
        
        print("Username: \(AppState.sharedInstance.displayName), Email: \(AppState.sharedInstance.email), uid: \(AppState.sharedInstance.uid), photoUrl: \(AppState.sharedInstance.photoUrl)")
        
        UserMgr.sendToFirebase(
            User(
                username: AppState.sharedInstance.displayName!,
                email: AppState.sharedInstance.email!
            ),
            uid: AppState.sharedInstance.uid!
        )
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NotificationKeys.SignedIn, object: nil, userInfo: nil)
        loadApp(sender)
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
    
}
