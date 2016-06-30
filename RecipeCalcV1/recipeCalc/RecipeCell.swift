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

class RecipeCell: MaterialTableViewCell {

    var recipeName: L1 = L1()
    var recipeDesc: L1 = L1()
    var creator: L1 = L1()
    var recipeID = ""
    
    override func prepareView() {
        super.prepareView()
        
        let cellView: MaterialView = MaterialView()
        contentView.addSubview(cellView)
        contentView.layout(cellView).top(8).left(8).bottom(8).right(8)
        
        recipeName.font = RobotoFont.regular
        recipeDesc.font = RobotoFont.regular
        recipeDesc.textColor = MaterialColor.grey.darken1
        creator.font = RobotoFont.regular
        creator.textColor = MaterialColor.grey.darken1
        
        cellView.backgroundColor = MaterialColor.clear
        
        let children = [recipeName, recipeDesc, creator]
        var dist = 0
        let spacing = 20
        for child in children {
            cellView.addSubview(child)
            cellView.layout(child).left(0).top(CGFloat(dist))
            dist += spacing
        }
        
    }

}