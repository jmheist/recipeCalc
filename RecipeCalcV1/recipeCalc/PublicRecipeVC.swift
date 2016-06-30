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
    
    var myRecipe: Bool = false
    let favMgr: FavoriteManager = FavoriteManager()
    var starRatingView: WDStarRatingView!
    
    override func viewDidLoad() {
        myRecipe = (AppState.sharedInstance.uid == recipe.authorId)
        super.viewDidLoad()
        if !myRecipe {
            prepareRating()
            prepareFav()
        }
    }
    
    override func prepareView() {
        view.backgroundColor = colors.background
    }
    
    override func prepareNavigationItem() {
        navigationItem.title = "Recipe"
    }
    
    func prepareRating() {
        
        let starView: MaterialView = MaterialView()
        view.layout(starView).top(5).right(5).height(50).width(100)
        
        let ratingLabel: L3 = L3()
        ratingLabel.textLayer.pointSize = 12
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
    
    func prepareFav() {
        let favView: MaterialView = MaterialView()
        favView.userInteractionEnabled = true
        view.layout(favView).top(55).right(5).height(20).width(100)
        
        let heartCount: L3 = L3()
        heartCount.textLayer.pointSize = 12
        heartCount.text = ""
        favView.layout(heartCount).left(20).top(0).bottom(0).width(80)
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 20, 20))
        
        favMgr.isRecipeFaved(recipe.key, uid: AppState.sharedInstance.uid!) { (isFaved) in
            if isFaved {
                imageView.image = MaterialIcon.favorite?.tintWithColor(colors.favorite)
                heartCount.text = "un fav"
                favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.unFav)))
            } else {
                imageView.image = MaterialIcon.favoriteBorder?.tintWithColor(colors.favorite)
                heartCount.text = "fav this recipe"
                
                favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fav)))
            }
        }
        
        favView.layout(imageView).left(0).top(0).bottom(0).width(20)
    }
    
    func fav() {
        favMgr.fav(recipe.key, uid: AppState.sharedInstance.uid!, authorUid: recipe.authorId)
        prepareFav()
    }
    
    func unFav() {
        favMgr.unFav(recipe.key, uid: AppState.sharedInstance.uid!, authorUid: recipe.authorId)
        prepareFav()
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
        print(myRecipe)
        recipeAuthor.text = "by \( myRecipe ? String("You") : recipe.author)"
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
    
    override func prepareTabBar() {
        
        let tabBar = MixTabBar()
        
        view.addSubview(tabBar)
        Layout.height(view, child: tabBar, height: 40)
        Layout.bottom(view, child: tabBar, bottom: 0)
        Layout.horizontally(view, child: tabBar, left: 0, right: 0)
        
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = colors.medium
        btn1.setTitle("Mix", forState: .Normal)
        btn1.setTitleColor(colors.text, forState: .Normal)
        btn1.addTarget(nil, action: #selector(mixIt), forControlEvents: .TouchUpInside)
        
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = colors.medium
        btn2.setTitle("Comments (1)", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(nil, action: #selector(commentOnRecipe), forControlEvents: .TouchUpInside)
        
        tabBar.buttons = [btn2, btn1]
        
    }
    
    func commentOnRecipe() {
        navigationController?.pushViewController(CommentsVC(recipe: self.recipe), animated: true)
    }
}