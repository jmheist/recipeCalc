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

class PublicRecipeVC: RecipeVC, WDStarRatingDelegate, UINavigationControllerDelegate {
    
    let favMgr: FavoriteManager = FavoriteManager()
    var starRatingView: WDStarRatingView!
    
    override func viewDidLoad() {
        myRecipe = (AppState.sharedInstance.signedInUser.uid == recipe.authorId)
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
        navigationController?.delegate = self
    }

    // app seems to work fine without passing the user back to the profile view
    
//    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//        if let controller = viewController as? ProfileVC {
//            controller.user = self.recipe.authorId    // Here you pass the data back to your original view controller
//        }
//    }
    
    func prepareRating() {
        
        let starView: MaterialView = MaterialView()
        view.layout(starView).top(116).height(60).centerHorizontally(-100).width(130)
        
        let ratingLabel: L3 = L3()
        ratingLabel.textLayer.pointSize = 12
        ratingLabel.text = "Rate this recipe"
        ratingLabel.textAlignment = .Center
        
        self.starRatingView = WDStarRatingView()
        self.starRatingView.delegate = self
        self.starRatingView.maximumValue = 5
        self.starRatingView.minimumValue = 0
        self.starRatingView.tintColor = colors.accent
        
        Queries.ratings.child(recipe.key).child(AppState.sharedInstance.signedInUser.uid!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if snapshot.value!.isKindOfClass(NSNull) {
                self.starRatingView.value = 0
            } else {
                self.starRatingView.value = snapshot.value as! CGFloat
            }
            self.starRatingView.addTarget(self, action: #selector(self.didChangeValue(_:)), forControlEvents: .ValueChanged)
        })
        
        starView.layout(ratingLabel).top(0).left(0).right(0)
        starView.layout(starRatingView).top(20).left(0).right(0).height(30)
        
    }
    
    func prepareFav() {
        
        let favView: MaterialView = MaterialView()
        favView.userInteractionEnabled = true
        view.layout(favView).top(116).height(60).centerHorizontally(100).width(130)
        
        let heartText: L3 = L3()
        heartText.textAlignment = .Center
        heartText.textLayer.pointSize = 12
        heartText.text = ""
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 20, 20))
        
        favMgr.isRecipeFaved(recipe.key, uid: AppState.sharedInstance.signedInUser.uid!) { (isFaved) in
            if isFaved {
                imageView.image = MaterialIcon.favorite?.tintWithColor(colors.favorite)
                heartText.text = "Remove favorite"
                favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.unFav)))
            } else {
                imageView.image = MaterialIcon.favoriteBorder?.tintWithColor(colors.favorite)
                heartText.text = "Favorite this recipe"
                
                favView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.fav)))
            }
        }
        
        favView.layout(heartText).top(0).left(0).right(0)
        favView.layout(imageView).top(20).centerHorizontally().width(30).height(30)

    }
    
    func fav() {
        favMgr.fav(recipe.key, uid: AppState.sharedInstance.signedInUser.uid!, authorUid: recipe.authorId)
        prepareFav()
    }
    
    func unFav() {
        favMgr.unFav(recipe.key, uid: AppState.sharedInstance.signedInUser.uid!, authorUid: recipe.authorId)
        prepareFav()
    }
    
    func didChangeValue(sender: WDStarRatingView) {
        ratingMgr.rate(Rating(stars: self.starRatingView.value, user: AppState.sharedInstance.signedInUser.uid!, recKey: recipe.key, recAuthUid: recipe.authorId))
    }
    
    override func prepareRecipe() {
        super.prepareRecipe()
        
        UserMgr.getUserByKey(recipe.authorId) { (user) in
            let text = (self.myRecipe ? "Your Recipe" : "by "+user.username!)
            self.recipeAuthor.text = text
            let authorTap = UITapGestureRecognizer(target: self, action: #selector(self.showAuthorProfile))
            self.recipeAuthor.addGestureRecognizer(authorTap)
            self.recipeAuthor.userInteractionEnabled = true
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
        btn2.setTitle("Comments", forState: .Normal)
        btn2.setTitleColor(colors.text, forState: .Normal)
        btn2.addTarget(nil, action: #selector(commentOnRecipe), forControlEvents: .TouchUpInside)
        
        // get comment count
        commentMgr.getCommentCountForRecipe(recipe.key) { (count) in
            if count > 0 {
                btn2.setTitle("Comments (\(count))", forState: .Normal)
            }
        }
        
        tabBar.buttons = [btn2, btn1]
        
    }
    
    func showAuthorProfile() {
        navigationController?.pushViewController(ProfileVC(user: self.recipe.authorId), animated: true)
    }
    
    func commentOnRecipe() {
        navigationController?.pushViewController(CommentsVC(recipe: self.recipe), animated: true)
    }
}