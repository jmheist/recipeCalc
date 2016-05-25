//
//  FireBaseService.swift
//  
//
//  Created by Jacob Heisterkamp on 5/24/16.
//
//

import Foundation
import Firebase

var fb: FirebaseManager = FirebaseManager()

class FirebaseManager: NSObject {
    
    var rootRef = FIRDatabase.database().reference()
    
    func isUserLoggedIn() -> Bool {
        var loggedIn = false
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            
            if let user = user {
                loggedIn = true
                print("User is already Logged in.")
            } else {
                print("Not Signed In")
            }
        }
        
        return loggedIn
    }
    
    func registerUser(emailAddress: String, password: String) -> Bool {
        
        var suc = false
        
        FIRAuth.auth()?.createUserWithEmail(emailAddress, password: password, completion: {
            
            user, error in
            
            if error != nil {
                self.login(emailAddress, password: password)
                suc = false
            } else {
                print("User Created")
                if self.login(emailAddress, password: password) {
                    suc = true
                }
            }
        })
        
        return suc
    }
    
    func login(emailAddress: String, password: String) -> Bool {
        
        var suc = false
        
        FIRAuth.auth()?.signInWithEmail(emailAddress, password: password, completion: {
            user, error in
            
            if error != nil {
                print("Error logging in")
            } else {
                print("Logged in Success")
                suc = true
            }
            
        })
        
        return suc
    }
    
    func logout() {
        try! FIRAuth.auth()!.signOut()
        self.isUserLoggedIn()
    }
    
    
}
