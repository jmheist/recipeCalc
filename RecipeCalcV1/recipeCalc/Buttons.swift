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
        cornerRadiusPreset = .Radius1
        contentEdgeInsetsPreset = .Square3
        backgroundColor = colors.background
        borderColor = colors.dark
        borderWidth = 1
        setTitleColor(colors.dark, forState: .Normal)
    }
}

class B2: MaterialButton {
    internal override func prepareView() {
        super.prepareView()
        setTitleColor(colors.textDark, forState: .Normal)
        cornerRadiusPreset = .Radius1
        contentEdgeInsetsPreset = .Square3
        backgroundColor = colors.background
        borderWidth = 0
    }
}

class B3: MaterialButton {
    internal override func prepareView() {
        super.prepareView()
        setTitleColor(colors.textDark, forState: .Normal)
        cornerRadiusPreset = .Radius1
        contentEdgeInsetsPreset = .Square3
        backgroundColor = colors.background
        borderWidth = 0
    }
}

