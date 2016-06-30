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

class PublicRecipeCell: RecipeCell, WDStarRatingDelegate {
    
    var ratingContainer: MaterialView!
    var starRatingView: WDStarRatingView!
    var starRatingCount: L3!
    var hearts: MaterialView!
    var heartCount: L3!
    
    override func prepareView() {
        super.prepareView()
        
        self.ratingContainer = MaterialView()
        contentView.layout(ratingContainer).top(10).right(3).height(15).width(120)
        
        self.starRatingView = WDStarRatingView()
        self.starRatingView.delegate = self
        self.starRatingView.maximumValue = 5
        self.starRatingView.minimumValue = 0
        self.starRatingView.value = 0
        self.starRatingView.tintColor = colors.accent
        self.starRatingView.enabled = false
        ratingContainer.layout(starRatingView).edges(left: 25, right: 20)
        
        self.starRatingCount = L3()
        starRatingCount.textLayer.pointSize = 12
        ratingContainer.layout(starRatingCount).right(0).top(0).bottom(0).width(20)
        
        self.hearts = MaterialView()
        ratingContainer.layout(hearts).left(0).top(0).bottom(0).width(30)
        
        self.heartCount = L3()
        self.heartCount.text = "0"
        self.heartCount.textLayer.pointSize = 12
        hearts.layout(heartCount).left(15).top(0).bottom(0).width(10)
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 15, 15))
        imageView.image = MaterialIcon.favorite?.tintWithColor(colors.favorite)
        
        hearts.layout(imageView).left(0).top(0).bottom(0).width(15)
    }
    
}