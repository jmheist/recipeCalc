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
    
    override func prepareView() {
        super.prepareView()
        
        self.starRatingView = WDStarRatingView()
        self.starRatingView.delegate = self
        self.starRatingView.maximumValue = 5
        self.starRatingView.minimumValue = 0
        self.starRatingView.value = 0
        self.starRatingView.tintColor = colors.accent
        //self.starRatingView.addTarget(self, action: #selector(ViewController.didChangeValue(_:)), forControlEvents: .ValueChanged)
        self.starRatingView.enabled = false
        
        contentView.layout(starRatingView).top(10).right(0).height(25).width(100)
        
    }
    
//    func didChangeValue(sender: WDStarRatingView) {
//        NSLog("Changed rating to %.1f", sender.value)
//    }
    
}