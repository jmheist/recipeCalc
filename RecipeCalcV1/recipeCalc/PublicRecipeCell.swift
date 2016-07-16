//
//  PublicRecipesCell.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class PublicRecipeCell: RecipeCell {
    
    var creator: L1 = L1()
    var profilePicView: UIImageView!
    
    override func prepareView() {
        super.prepareView()
        
        self.profilePicView = UIImageView()
        self.profilePicView.layer.cornerRadius = 8
        self.profilePicView.clipsToBounds = true
        self.profilePicView.backgroundColor = colors.background
        contentView.layout(profilePicView).top(28).left(8).height(16).width(16)
        
        creator.font = RobotoFont.lightWithSize(13)
        creator.textColor = MaterialColor.grey.darken1
        contentView.layout(creator).top(28).bottom(8).left(28).width(250)
    }
    
}