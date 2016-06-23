//
//  Labels.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class L1: MaterialLabel {
    override func prepareView() {
        font = RobotoFont.boldWithSize(22)
    }
}

class L2: MaterialLabel {
    override func prepareView() {
        font = RobotoFont.regularWithSize(18)
    }
}

class L3: MaterialLabel {
    override func prepareView() {
        font = RobotoFont.thinWithSize(16)
    }
}

class StepDescLabel: MaterialLabel {
    override func prepareView() {
        font = RobotoFont.thinWithSize(16)
        numberOfLines = 0
    }
}
