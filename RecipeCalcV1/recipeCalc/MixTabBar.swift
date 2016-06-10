//
//  MixTabBar.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/9/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class MixTabBar: TabBar {
    
    override func prepareView() {
        super.prepareView()
        backgroundColor = colors.background
        line.tintColor = colors.light
        prepareBottomLayer()
    }
    
    // Prepares the bottomLayer.
    private func prepareBottomLayer() {
        line.backgroundColor = colors.background
    }
    
}
