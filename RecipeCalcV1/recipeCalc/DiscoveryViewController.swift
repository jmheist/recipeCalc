//
//  DiscoveryViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/26/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class DiscoveryViewController: UIViewController {

    //
    // bottom nav setup
    //
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.grey.lighten5
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Discover"
        tabBarItem.image = MaterialIcon.visibility
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    //
    // end bottom nav setup
    //
    
}
