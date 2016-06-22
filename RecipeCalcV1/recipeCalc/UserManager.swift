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
    
    var users: [String: User] = [:]
    
    func sendToFirebase(user: User, uid: String) {
        
        Queries.users.child(uid).setValue(user.fb())
        
    }
    
    func reset() {
        users = [:]
    }
    
    func getUsers() {
        print("getUsers()")
        Queries.users.removeAllObservers()
        Queries.users.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            print("querying")
            self.reset()
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                self.users[snap.key] = User(
                    username: snap.value!["username"] as! String,
                    email: snap.value!["email"] as! String
                )
            }
            print(self.users.count)
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
    
}
