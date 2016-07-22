//
//  RatingManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/15/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

struct Rating {
    
    let stars: CGFloat!
    let user: String!
    let recKey: String!
    let recAuthUid: String!
    
    init(stars: CGFloat, user: String, recKey: String, recAuthUid: String) {
        self.stars = stars
        self.user = user
        self.recKey = recKey
        self.recAuthUid = recAuthUid
    }
    
}

let ratingMgr: RatingManager = RatingManager()

class RatingManager: NSObject {
    
    func rate(rating: Rating) {
        Queries.ratings.child(rating.recKey).child(rating.user).setValue(rating.stars)
        
        // Get the ratings for this recipe
        Queries.ratings.child(rating.recKey).removeAllObservers()
        Queries.ratings.child(rating.recKey).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            var ratings = [CGFloat]()
            var starTotal: Double = 0
            var starCount: Int = 0
            for child in snapshot.children {
                starCount += 1
                let snap = child as! FIRDataSnapshot
                ratings.append(snap.value as! CGFloat)
                starTotal += snap.value as! Double
            }
            let stars = String(CGFloat(starTotal / Double(ratings.count))) == "nan" ? CGFloat(0) : CGFloat(starTotal / Double(ratings.count))
            print("Updateing Stars on recipes with: \(stars)")
            Queries.myRecipes.child(rating.recAuthUid).child(rating.recKey).child("stars").setValue(stars)
            Queries.myRecipes.child(rating.recAuthUid).child(rating.recKey).child("starsCount").setValue(starCount)
            Queries.publicRecipes.child(rating.recKey).child("stars").setValue(stars)
            Queries.publicRecipes.child(rating.recKey).child("starsCount").setValue(starCount)
        }) // end get ratings

    }
    
}