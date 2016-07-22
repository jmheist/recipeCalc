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
        shadowColor = colors.dark
        shadowOffset = CGSize(width: 0,height: -1)
        shadowRadius = 1
        shadowOpacity = 1
    }
    
    // Prepares the bottomLayer.
    private func prepareBottomLayer() {
        line.backgroundColor = colors.background
    }
    
}
