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
    
    var publishedText: L3!
    
    override func prepareView() {
        super.prepareView()
        
        contentView.layout(recipeName).top(8).left(8).width(250)
        contentView.layout(ratingContainer).top(28).bottom(8).left(8).height(15).width(120)
        
        publishedText = L3()
        publishedText.text = "Not Published"
        publishedText.textLayer.pointSize = 12
        publishedText.hidden = true
        contentView.layout(publishedText).top(28).bottom(8).left(8).height(15).width(120)
    }
    
}