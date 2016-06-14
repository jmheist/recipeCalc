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
    
    override func prepareView() {
        super.prepareView()
        let starView: MaterialView = MaterialView()
        starView.backgroundColor = colors.light
        contentView.addSubview(starView)
        Layout.size(contentView, child: starView, width: 70, height: 20)
        Layout.topRight(contentView, child: starView, top: 10, right: 10)
        
        let star1: UIImageView = UIImageView(image: MaterialIcon.star?.tintWithColor(colors.dark))
        let star2: UIImageView = UIImageView(image: MaterialIcon.star)
        let star3: UIImageView = UIImageView(image: MaterialIcon.star)
        let star4: UIImageView = UIImageView(image: MaterialIcon.star)
        let star5: UIImageView = UIImageView(image: MaterialIcon.star)
        let stars = [star1, star2, star3, star4, star5]
        
        for star in stars {
            starView.addSubview(star)
            
        }
        Layout.vertically(starView, children: stars, top: 5, bottom: 5, spacing: 5)
        
        
    }
    
}