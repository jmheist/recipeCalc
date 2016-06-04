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
    
    var recipeKey: String?
    var recipeRef: FIRDatabaseReference!

    override func prepareView() {
        super.prepareView()
        
        let cellView: MaterialView = MaterialView()
        contentView.addSubview(cellView)
        MaterialLayout.alignToParent(contentView, child: cellView, top: 10, left: 10, bottom: 10, right: 10)
        
        cellView.backgroundColor = MaterialColor.clear
        
        cellView.addSubview(recipeName)
        cellView.addSubview(recipeDesc)
        cellView.addSubview(creator)
        
        MaterialLayout.width(contentView, child: recipeName, width: 300)
        MaterialLayout.width(contentView, child: recipeDesc, width: 300)
        MaterialLayout.width(contentView, child: creator, width: 300)
        
        MaterialLayout.alignFromTopLeft(contentView, child: recipeName, top: 0, left: 0)
        MaterialLayout.alignFromTopLeft(contentView, child: recipeDesc, top: 20, left: 0)
        MaterialLayout.alignFromTopLeft(contentView, child: creator, top: 40, left: 0)
    }

}