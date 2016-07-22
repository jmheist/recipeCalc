//
//  BottomNav.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/2/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class BottomNav: BottomNavigationController {
    
    override func prepareView() {
        super.prepareView()
        selectedIndex = 0
        tabBar.tintColor = colors.dark
        tabBar.backgroundColor = colors.background
        let image: UIImage? = UIImage.imageWithColor(colors.dark, size: CGSizeMake(1, 1))
        tabBar.shadowImage = image

        tabBarItem.setTitleColor(colors.medium, forState: .Normal)
        tabBarItem.setTitleColor(colors.dark, forState: .Selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
