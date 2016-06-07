//
//  RecipeVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/6/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class RecipeVC: UIViewController {
    
    private var recipe: FIRDataSnapshot!
    private var flavors: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: FIRDataSnapshot) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareFlavors()
        prepareView()
        prepareNavigationItem()
        print(recipe)
        print("flavors: \(flavors.count)")
    }
    
    deinit {
        Queries.flavors.child(recipe.key).removeObserverWithHandle(_refHandle)
    }
    
    // Queries.flavors.child(recipes[indexPath.row].key)
    func prepareFlavors() {
        _refHandle = Queries.flavors.child(recipe.key).observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            self.flavors.append(snapshot)
            print(snapshot)
        })
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
        print(flavors.count)
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = ""
    }
    
}
