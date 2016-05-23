//
//  TaskManager.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit

struct flavor {
    
    var name = ""
    var base = 0
    var pct = ""
    
}

let flavorMGR: FlavorManager = FlavorManager()

class FlavorManager: NSObject {
    
    var flavors = [flavor]()
    
    func addFlavor(name: String, base: Int, pct: String) {
        flavors.append(flavor(name: name, base: base, pct: pct))
    }
    
    func reset() {
        flavors.removeAll()
    }
    
}


