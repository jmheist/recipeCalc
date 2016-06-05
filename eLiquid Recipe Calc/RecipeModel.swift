//
//  TaskModel.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import Foundation
import RealmSwift

class Flavor: Object {
    
    dynamic var name = ""
    dynamic var base = 0
    dynamic var pct = ""
    
}

class Settings: Object {
    
    dynamic var mixAmount = ""
    dynamic var nicStrength = ""
    dynamic var nicBase = 0
    dynamic var nicTarget = ""
    dynamic var pgStandardGrams = ""
    dynamic var vgStandardGrams = ""
    dynamic var nicStandardGrams = ""
    dynamic var flavorStandardGrams = ""
    dynamic var waterStandardGrams = ""
    
}

class Recipe: Object {
    
    dynamic var name = ""
    dynamic var desc = ""
    dynamic var pgPct = ""
    dynamic var vgPct = ""
    dynamic var id = 0
    let flavors = List<Flavor>()
    let settings = List<Settings>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

let realm = try! Realm()