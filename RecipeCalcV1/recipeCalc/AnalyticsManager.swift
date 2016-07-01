//
//  AnalyticsManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 7/1/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

let analyticsMgr: AnalyticsManager = AnalyticsManager()

class AnalyticsManager: NSObject {
    
    func sendLoginEvent() {
        FIRAnalytics.logEventWithName(kFIREventLogin, parameters: nil)
    }
    
    func sendLogoutEvent() {
        FIRAnalytics.logEventWithName("logout", parameters: nil)
    }
    
    func sendRecipeCreated() {
        FIRAnalytics.logEventWithName("recipe_created", parameters: nil)
    }
    
    func sendRecipeDeleted() {
        FIRAnalytics.logEventWithName("recipe_deleted", parameters: nil)
    }
    
    func sendCommentMade() {
        FIRAnalytics.logEventWithName("comment_made", parameters: nil)
    }
    
    func sendRecipeMixed() {
        FIRAnalytics.logEventWithName("recipe_mixed", parameters: nil)
    }
    
    func sendRecipePublished() {
        FIRAnalytics.logEventWithName("recipe_published", parameters: nil)
    }
    
    func sendRecipeUnpublished() {
        FIRAnalytics.logEventWithName("recipe_unpublished", parameters: nil)
    }
    
    func sendPublicRecipeViewed() {
        FIRAnalytics.logEventWithName("public_recipe_viewed", parameters: nil)
    }
    
}
