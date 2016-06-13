//
//  AppNav.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/2/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class AppNav: NavigationController {
 
    /// StatusBar color reference.
    private var statusBarView: MaterialView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareStatusBarView()
        prepareNavigationBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        statusBarView?.hidden = MaterialDevice.statusBarHidden
    }
    
    /// Prepares the statusBarView
    private func prepareStatusBarView() {
        statusBarView = MaterialView()
        statusBarView!.backgroundColor = colors.dark
        view.addSubview(statusBarView!)
        MaterialLayout.alignFromTop(view, child: statusBarView!)
        MaterialLayout.alignToParentHorizontally(view, child: statusBarView!)
        MaterialLayout.height(view, child: statusBarView!, height: 16)
    }
    
    /// Prepares the navigationBar
    private func prepareNavigationBar() {
        navigationBar.tintColor = colors.dark
        navigationBar.backgroundColor = colors.background
        let image: UIImage? = UIImage.imageWithColor(colors.dark, size: CGSizeMake(1, 1))
        navigationBar.shadowImage = image
        
        navigationItem.titleLabel.textAlignment = .Center
        navigationItem.titleLabel.textColor = colors.dark
        navigationItem.titleLabel.font = RobotoFont.thinWithSize(16)
    }
}
