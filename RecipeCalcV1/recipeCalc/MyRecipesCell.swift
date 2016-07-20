//
//  MyRecipesCell.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class MyRecipeCell: RecipeCell {
    
    override func prepareView() {
        super.prepareView()
        
        contentView.layout(recipeName).top(8).left(8).width(250)
        contentView.layout(ratingContainer).top(32).bottom(8).left(8).height(15).width(120)
    }
    
}