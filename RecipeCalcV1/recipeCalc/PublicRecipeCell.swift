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
    
    var starRatingView: WDStarRatingView!
    var starRatingContainer: MaterialView!
    var starRatingCount: L3!
    
    override func prepareView() {
        super.prepareView()
        
        self.starRatingContainer = MaterialView()
        contentView.layout(starRatingContainer).top(10).right(3).height(20).width(80)
        
        self.starRatingView = WDStarRatingView()
        self.starRatingView.delegate = self
        self.starRatingView.maximumValue = 5
        self.starRatingView.minimumValue = 0
        self.starRatingView.value = 0
        self.starRatingView.tintColor = colors.accent
        //self.starRatingView.addTarget(self, action: #selector(ViewController.didChangeValue(_:)), forControlEvents: .ValueChanged)
        self.starRatingView.enabled = false
        starRatingContainer.layout(starRatingView).edges(right: 20)
        
        self.starRatingCount = L3()
        self.starRatingCount.textLayer.textAlignment = .Center
        starRatingContainer.layout(starRatingCount).top(0).bottom(0).right(0).width(20)
        
    }
    
}