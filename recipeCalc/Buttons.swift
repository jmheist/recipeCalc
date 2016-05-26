//
//  B1.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class B1: MaterialButton {
    internal override func prepareView() {
        super.prepareView()
        shadowColor = MaterialColor.purple.darken2
        shadowOpacity = 30
        shadowOffset.height = 10
        shadowOffset.width = 10
        shadowRadius = 5
        shadowPathAutoSizeEnabled = true
        backgroundColor = MaterialColor.amber.darken3
    }
}

class B2: MaterialButton {
    
}

class B3: MaterialButton {
    
}

