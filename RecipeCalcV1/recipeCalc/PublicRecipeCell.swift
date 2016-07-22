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
        self.profilePicView.layer.cornerRadius = 19
        self.profilePicView.clipsToBounds = true
        self.profilePicView.backgroundColor = colors.background
        contentView.layout(profilePicView).top(9).bottom(9).left(6).height(38).width(38)
        
        contentView.layout(recipeName).top(8).left(50).right(8)
        
        creator.font = RobotoFont.lightWithSize(13)
        creator.textColor = MaterialColor.grey.darken1
        contentView.layout(creator).top(28).left(50).width(250)
        
        contentView.layout(ratingContainer).top(28).right(8).height(15).width(120)
    }
    
}