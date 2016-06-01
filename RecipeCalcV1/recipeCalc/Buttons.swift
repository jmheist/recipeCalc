//
//  B1.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class B1: FlatButton {
    internal override func prepareView() {
        super.prepareView()
        cornerRadiusPreset = .Radius3
        contentEdgeInsetsPreset = .WideRectangle3
        backgroundColor = MaterialColor.white
        borderColor = MaterialColor.black
        borderWidth = 1
        setTitleColor(MaterialColor.black, forState: .Normal)
    }
}

class B2: MaterialButton {
    
}

class B3: MaterialButton {
    
}

