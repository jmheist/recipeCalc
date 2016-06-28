//
//  MyRecipeVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/6/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class PublicRecipeVC: RecipeVC, WDStarRatingDelegate {
    
    var starRatingView: WDStarRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRating()
    }
    
    override func prepareView() {
        view.backgroundColor = colors.background
    }
    
    override func prepareNavigationItem() {
        navigationItem.title = "Recipe"
    }
    
    func prepareRating() {
        
        let starView: MaterialView = MaterialView()
        view.addSubview(starView)
        view.layout(starView).top(5).right(5).height(50).width(100)
        
        let ratingLabel: L3 = L3()
        ratingLabel.text = "rate this recipe"
        ratingLabel.textAlignment = .Right
        
        self.starRatingView = WDStarRatingView()
        self.starRatingView.delegate = self
        self.starRatingView.maximumValue = 5
        self.starRatingView.minimumValue = 0
        self.starRatingView.tintColor = colors.accent
        
        Queries.ratings.child(recipe.key).child(AppState.sharedInstance.uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value!.isKindOfClass(NSNull) {
                self.starRatingView.value = 0
            } else {
                self.starRatingView.value = snapshot.value as! CGFloat
            }
            self.starRatingView.addTarget(self, action: #selector(self.didChangeValue(_:)), forControlEvents: .ValueChanged)
        })
        
        let children = [ratingLabel, starRatingView]
        let spacing = 20
        var dist = 0
        for child in children {
            starView.addSubview(child)
            starView.layout(child).top(CGFloat(dist)).right(5).height(25).width(100)
            dist += spacing
        }
    }
    
    func didChangeValue(sender: WDStarRatingView) {
        ratingMgr.rate(Rating(stars: self.starRatingView.value, user: AppState.sharedInstance.uid!, recKey: recipe.key, recAuthUid: recipe.authorId))
    }
    
    override func prepareRecipe() {
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        Layout.edges(view, child: recipeInfo, top: 0, left: 0, bottom: 99, right: 0)
        
        let recipeName: L1 = L1()
        let recipeDesc: L2 = L2()
        let recipeAuthor: L3 = L3()
        
        recipeName.text = recipe.name
        recipeName.textAlignment = .Left
        
        recipeDesc.text = recipe.desc
        recipeDesc.textAlignment = .Left
        
        recipeAuthor.text = "by \(recipe.author)"
        recipeAuthor.textAlignment = .Left
        
        let children = [recipeName, recipeDesc, recipeAuthor]
        
        var spacing = 30
        var dist = 5
        for child in children {
            recipeInfo.addSubview(child)
            recipeInfo.layout(child).top(CGFloat(dist)).left(8).width(200).height(30)
            spacing -= 5
            dist += spacing
        }
        
        
    }
}