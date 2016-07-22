//
//  MixSettingsManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/8/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

struct WeightSettings {

    var vgWeight = Float(1.26)
    var pgWeight = Float(1.038)
    var nicWeight = Float(1.01)
    var flavorWeight = Float(1.0)
    
//    init(vgWeight: Float, pgWeight: Float, nicWeight: Float, flavorWeight: Float) {
//        self.vgWeight = vgWeight
//        self.pgWeight = pgWeight
//        self.nicWeight = nicWeight
//        self.flavorWeight = flavorWeight
//    }
    
}

struct MixSettings {

    var amount = Float()
    var strength = Float()
    var pg = Float()
    var vg = Float()
    var nic = Float()

    init(amount: Float, strength: Float, pg: Float, vg: Float, nic: Float) {
        self.amount = amount
        self.strength = strength
        self.pg = pg
        self.vg = vg
        self.nic = nic
    }
    
    func fb() -> AnyObject {
        var mixSetting = [String: AnyObject]()
        mixSetting["amount"] = self.amount
        mixSetting["strength"] = self.strength
        mixSetting["pg"] = self.pg
        mixSetting["vg"] = self.vg
        mixSetting["nic"] = self.nic
        return mixSetting
    }

}

let mixMgr: MixManager = MixManager()

class MixManager: NSObject {
    
    func getUserRecipeSettings(uid: String, recipe: String, completionHandler:(MixSettings)->()) {
        
        Queries.mixSettings.child(uid).child(recipe).observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            self.reciveMixSettingsFromFB(snapshot, completionHandler: { (settings) in
                completionHandler(settings)
            })
        })
        
    }
    
    func reciveMixSettingsFromFB(snap: FIRDataSnapshot, completionHandler:(MixSettings)->()) {
        if !snap.value!.isKindOfClass(NSNull) {
            print(snap.value!)
            let amount = snap.value!["amount"] as! Float
            let strength = snap.value!["strength"] as! Float
            let pg = snap.value!["pg"] as! Float
            let vg = snap.value!["vg"] as! Float
            let nic = snap.value!["nic"] as! Float
            
            let settings = MixSettings(amount: amount, strength: strength, pg: pg, vg: vg, nic: nic)
            completionHandler(settings)
        }
    }
    
    func saveMixSettingsToFB(uid: String, recipe: String, settings: MixSettings) {
        Queries.mixSettings.child(uid).child(recipe).setValue(settings.fb())
    }
    
}