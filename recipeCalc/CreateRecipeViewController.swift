//
//  CreateRecipeViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class CreateRecipeViewController: UIViewController {

    
    
    
    
    
    
    /// Reference for containerView.
    private var containerView: UIView!
    
    /// Reference for Toolbar.
    private var toolbar: Toolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareContainerView()
        prepareToolbar()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }
    
    /// Prepares the containerView.
    private func prepareContainerView() {
        containerView = UIView()
        view.addSubview(containerView)
        
        MaterialLayout.alignToParent(view, child: containerView, top: 24, left: 0, right: 0)
    }
    
    /// Prepares the toolbar
    private func prepareToolbar() {
        toolbar = Toolbar()
        containerView.addSubview(toolbar)
        
        // Title label.
        toolbar.titleLabel.text = "Material"
        toolbar.titleLabel.textColor = MaterialColor.white
        
        // Detail label.
        toolbar.detailLabel.text = "Build Beautiful Software"
        toolbar.detailLabel.textColor = MaterialColor.white
        
        var image: UIImage? = MaterialIcon.cm.arrowBack
        
        // Menu button.
        let menuButton: IconButton = IconButton()
        menuButton.pulseColor = MaterialColor.white
        menuButton.tintColor = MaterialColor.white
        menuButton.setImage(image, forState: .Normal)
        menuButton.setImage(image, forState: .Highlighted)
        
        // Switch control.
        let switchControl: MaterialSwitch = MaterialSwitch(state: .Off, style: .LightContent, size: .Small)
        
        // Search button.
        image = MaterialIcon.cm.search
        let searchButton: IconButton = IconButton()
        searchButton.pulseColor = MaterialColor.white
        searchButton.tintColor = MaterialColor.white
        searchButton.setImage(image, forState: .Normal)
        searchButton.setImage(image, forState: .Highlighted)
        
        /*
         To lighten the status bar - add the
         "View controller-based status bar appearance = NO"
         to your info.plist file and set the following property.
         */
        toolbar.backgroundColor = MaterialColor.blue.base
        toolbar.leftControls = [menuButton]
        toolbar.rightControls = [switchControl, searchButton]
    }
    
}
