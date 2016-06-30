//
//  FavoriteManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/29/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

class FavoriteManager: NSObject {
    
    func fav(recipeId: String, uid: String, authorUid: String) {
        print("faving")
        Queries.favs.child(recipeId).child(uid).setValue(true)
        self.updateFavCount(recipeId, authorUid: authorUid)
        self.addToUserFavList(recipeId, uid: uid)
    }
    
    func unFav(recipeId: String, uid: String, authorUid: String) {
        print("unfaving")
        Queries.favs.child(recipeId).child(uid).setValue(nil)
        self.updateFavCount(recipeId, authorUid: authorUid)
        self.removeFromUserFavList(recipeId, uid: uid)
    }
    
    func isRecipeFaved(recipeId: String, uid: String, completionHandler:(Bool)->()) {
        Queries.favs.child(recipeId).child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.value!.isKindOfClass(NSNull) && snapshot.value as! Bool == true {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        })
    }
    
    func getUserFavs(uid: String, completion:([Recipe])->()) {
        
        var favs: [Recipe] = []
        var favKeys: [String] = []
        
        func getRecipeData() {
            for key in favKeys {
                Queries.publicRecipes.child(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    favs.append(publicRecipeMgr.receiveFromFirebase(snapshot))
                    if favs.count == favKeys.count {
                        finish()
                    }
                })
            }
        }
        
        func finish() {
            completion(favs)
        }
        
        Queries.userFavs.child(uid).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                favKeys.append(child.key)
            }
            getRecipeData()
        })
        
    }
    
    private func updateFavCount(recipeId: String, authorUid: String) {
        Queries.favs.child(recipeId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var favCount = 0
            for _ in snapshot.children {
                favCount += 1
            }
            Queries.myRecipes.child(authorUid).child(recipeId).child("favCount").setValue(favCount)
            Queries.publicRecipes.child(recipeId).child("favCount").setValue(favCount)
        })
    }
    
    private func addToUserFavList(recipeId: String, uid: String) {
        Queries.userFavs.child(uid).child(recipeId).setValue(true)
    }
    
    private func removeFromUserFavList(recipeId: String, uid: String) {
        Queries.userFavs.child(uid).child(recipeId).removeValue()
    }
    
}
