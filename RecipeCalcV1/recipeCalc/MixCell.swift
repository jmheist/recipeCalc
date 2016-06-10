//
//  RecipeCell.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class MixCell: MaterialTableViewCell {
    
    var name: L2 = L2()
    var ml: L2 = L2()
    var grams: L2 = L2()
    var pct: L2 = L2()
    
    override func prepareView() {
        super.prepareView()
        
        let cellView: MaterialView = MaterialView()
        contentView.addSubview(cellView)
        MaterialLayout.alignToParent(contentView, child: cellView, top: 5, left: 0, bottom: 5, right: 0)
        
        cellView.backgroundColor = MaterialColor.clear
        
        let children = [name, ml, grams, pct]
        
        for child in children {
            cellView.addSubview(child)
            MaterialLayout.alignToParentVertically(cellView, child: child, top: 0, bottom: 0)
        }
        
        MaterialLayout.alignFromLeft(cellView, child: name, left: 0)
        MaterialLayout.alignFromRight(cellView, child: grams, right: 120)
        MaterialLayout.alignFromRight(cellView, child: ml, right: 60)
        MaterialLayout.alignFromRight(cellView, child: pct, right: 0)
        
    }
    
}