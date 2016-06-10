//
//  MixSettingsManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/8/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

struct Settings {
    
    var amount = Float()
    var strength = Float()
    var pg = Float()
    var vg = Float()
    var nic = Float()
    var vgWeight = Float(1.26)
    var pgWeight = Float(1.038)
    var nicWeight = Float(1.01)
    var flavorWeight = Float(1.0)
    
    init(amount: String, strength: String, pg: String, vg: String, nic: String) {
        self.amount = Float(amount)!
        self.strength = Float(strength)!
        self.pg = Float(pg)!/100
        self.vg = Float(vg)!/100
        self.nic = Float(nic)!
    }
    
}