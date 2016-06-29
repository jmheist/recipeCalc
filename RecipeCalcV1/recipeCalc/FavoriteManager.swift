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
    
    func fav(recipeId: String, uid: String) {
        Queries.favs.child(recipeId).child(uid).setValue(true)
        Queries.favs.child(recipeId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var favCount = 0
            for _ in snapshot.children {
                favCount += 1
            }
            Queries.myRecipes.child(uid).child(recipeId).child("favCount").setValue(favCount)
            Queries.publicRecipes.child(recipeId).child("favCount").setValue(favCount)
        })
    }
    
}
