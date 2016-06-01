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
    
    private var recipeName: TextField!;
    private var recipeDesc: TextField!;
    private var recipePgPct: TextField!;
    private var recipeVgPct: TextField!;
    private var recipeSteepDays: TextField!;
    private var addFlavorName: TextField!;
    private var addFlavorBase: UISegmentedControl!;
    private var addFlavorPct: TextField!;
    private var addFlavorButton: FlatButton!;
    
    private var flavorTable: UITableView!
    let cellIdentifier = "FlavorCell"

    
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
        prepareTitlebar()
        prepareTextFields()
        prepareFlavorTable()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create"
        tabBarItem.image = MaterialIcon.add
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "Create a Recipe"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let recipeInfo: MaterialView = MaterialView()
        recipeInfo.backgroundColor = colors.lightGrey
        view.addSubview(recipeInfo)
        
        MaterialLayout.height(view, child: recipeInfo, height: 165)
        MaterialLayout.alignFromTop(view, child: recipeInfo, top: 65)
        MaterialLayout.alignToParentHorizontally(view, child: recipeInfo, left: 14, right: 14)
        
        // recipe info fields
        
        recipeName = TextField()
        recipeName.placeholder = "Recipe Name"
        recipeName.font = RobotoFont.regularWithSize(24)
        recipeName.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeName)
        MaterialLayout.height(recipeInfo, child: recipeName, height: 28)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 25)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName, left: 10, right: 10)
        
        recipeDesc = TextField()
        recipeDesc.placeholder = "Recipe Description"
        recipeDesc.font = RobotoFont.regularWithSize(20)
        recipeDesc.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeDesc)
        MaterialLayout.height(recipeInfo, child: recipeDesc, height: 20)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 85)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc, left: 10, right: 10)
        
        recipePgPct = TextField()
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.font = RobotoFont.regularWithSize(14)
        recipePgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipePgPct)
        MaterialLayout.size(recipeInfo, child: recipePgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipePgPct, left: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipePgPct, top: 130)
        
        recipeVgPct = TextField()
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.font = RobotoFont.regularWithSize(14)
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeVgPct)
        MaterialLayout.size(recipeInfo, child: recipeVgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeVgPct, left: 100)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeVgPct, top: 130)
        
        recipeSteepDays = TextField()
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.font = RobotoFont.regularWithSize(14)
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeSteepDays)
        MaterialLayout.size(recipeInfo, child: recipeSteepDays, width: 120, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeSteepDays, left: 200)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeSteepDays, top: 130)
        
        // Flavor Info
        
        let flavorInfo: MaterialView = MaterialView()
        flavorInfo.backgroundColor = colors.medGrey
        view.addSubview(flavorInfo)
        
        MaterialLayout.height(view, child: flavorInfo, height: 145)
        MaterialLayout.alignFromTop(view, child: flavorInfo, top: 240)
        MaterialLayout.alignToParentHorizontally(view, child: flavorInfo, left: 14, right: 14)
        
        addFlavorName = TextField()
        addFlavorName.placeholder = "Flavor Name"
        addFlavorName.font = RobotoFont.regularWithSize(20)
        addFlavorName.clearButtonMode = .WhileEditing
        flavorInfo.addSubview(addFlavorName)
        MaterialLayout.height(flavorInfo, child: addFlavorName, height: 22)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorName, top: 22)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorName, left: 10, right: 10)
        
        addFlavorPct = TextField()
        addFlavorPct.placeholder = "%"
        addFlavorPct.font = RobotoFont.regularWithSize(18)
        addFlavorPct.clearButtonMode = .WhileEditing
        flavorInfo.addSubview(addFlavorPct)
        MaterialLayout.size(flavorInfo, child: addFlavorPct, width: 50, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: addFlavorPct, left: 10)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorPct, top: 70)
        
        
        let flavorBaseLabel: MaterialLabel = MaterialLabel()
        flavorBaseLabel.text = "Flavor base"
        flavorBaseLabel.font = RobotoFont.regularWithSize(16)
        flavorInfo.addSubview(flavorBaseLabel)
        MaterialLayout.size(flavorInfo, child: flavorBaseLabel, width: 110, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: flavorBaseLabel, left: 110)
        MaterialLayout.alignFromTop(flavorInfo, child: flavorBaseLabel, top: 70)
        
        addFlavorBase = UISegmentedControl(items: ["PG","VG"])
        addFlavorBase.selectedSegmentIndex = 0
        flavorInfo.addSubview(addFlavorBase)
        MaterialLayout.size(flavorInfo, child: addFlavorBase, width: 80, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: addFlavorBase, left: 215)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorBase, top: 70)
        
        addFlavorButton = FlatButton()
        addFlavorButton.setTitle("Add Flavor", forState: .Normal)
        addFlavorButton.setTitleColor(colors.buttonText, forState: .Normal)
        flavorInfo.addSubview(addFlavorButton)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorButton, left: 30, right: 30)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorButton, top: 100)
        
    }
    
    func prepareFlavorTable() {
    
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(flavorTable)
        MaterialLayout.alignToParent(view, child: flavorTable, top: 400, bottom: 49)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
}


/// TableViewDataSource methods.
extension CreateRecipeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecipeCell = RecipeCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = "Flavor Name \(indexPath.row)"
        cell.detailTextLabel?.text = "6%\t\tBase: VG"
        return cell
    }
    
}

/// UITableViewDelegate methods.
extension CreateRecipeViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //
    }
}
