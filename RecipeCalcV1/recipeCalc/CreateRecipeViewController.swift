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
    
    // text fields
    
    private var recipeName: TextField!,
                recipeDesc: TextField!,
                recipePgPct: TextField!,
                recipeVgPct: TextField!,
                addFlavorName: TextField!,
                addFlavorBase: MaterialSwitch!,
                addFlavorPct: TextField!;
    
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
        tabBarItem.title = "Create"
        tabBarItem.image = MaterialIcon.add
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareTextFields() {
        
        
//        emailField = ErrorTextField(frame: CGRectMake(40, 120, view.bounds.width - 80, 32))
//        emailField.placeholder = "Email"
//        emailField.detail = "Error, incorrect email"
//        emailField.enableClearIconButton = true
//        emailField.delegate = self
//        
//        emailField.placeholderColor = MaterialColor.amber.darken4
//        emailField.placeholderActiveColor = MaterialColor.pink.base
//        emailField.dividerColor = MaterialColor.cyan.base
//        
//        view.addSubview(emailField)
        
        
    }  // End text Fields
    
}
