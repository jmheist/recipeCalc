//
//  CreateRecipeViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

class CreateRecipeViewController: UIViewController, UITextFieldDelegate {
    
    // text fields
    
    private var recipeName: T1!;
    private var recipeDesc: T2!;
    private var recipePgPct: T2!;
    private var recipeVgPct: T2!;
    private var recipeSteepDays: T2!;
    
    private var addFlavorName: T1!;
    private var addFlavorBase: UISegmentedControl!;
    private var addFlavorPct: T2!;
    private var addFlavorButton: B2!;
    
    // flavors
    let flavorMGR: FlavorManager = FlavorManager()
    
    // nav save button
    private var saveBtn: B2!
    
    // table vars
    private var flavorTable: UITableView!
    let cellIdentifier = "FlavorCell"
    
    // db vars
    var ref: FIRDatabaseReference!
    var recipes: [FIRDataSnapshot]! = []
    private var _refHandle: FIRDatabaseHandle!

    
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
        configureDatabase()
        prepareView()
        prepareNavigationItem()
        prepareTextFields()
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create"
        tabBarItem.image = MaterialIcon.add
    }
    
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Create"
        
        saveBtn = B2()
        saveBtn.setTitle("Save", forState: .Normal)
        saveBtn.addTarget(self, action: #selector(sendRecipe), forControlEvents: .TouchUpInside)
        
        navigationItem.rightControls = [saveBtn]
        
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let recipeInfo: MaterialView = MaterialView()
        view.addSubview(recipeInfo)
        
        MaterialLayout.height(view, child: recipeInfo, height: 170)
        MaterialLayout.alignFromTop(view, child: recipeInfo, top: 0)
        MaterialLayout.alignToParentHorizontally(view, child: recipeInfo, left: 14, right: 14)
        
        // recipe info fields
        
        recipeName = T1()
        recipeName.placeholder = "Recipe Name"
        recipeName.font = RobotoFont.regularWithSize(24)
        recipeName.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeName)
        MaterialLayout.height(recipeInfo, child: recipeName, height: 28)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeName, top: 25)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeName, left: 10, right: 10)
        
        recipeDesc = T2()
        recipeDesc.placeholder = "Recipe Description"
        recipeDesc.font = RobotoFont.regularWithSize(20)
        recipeDesc.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeDesc)
        MaterialLayout.height(recipeInfo, child: recipeDesc, height: 20)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeDesc, top: 85)
        MaterialLayout.alignToParentHorizontally(recipeInfo, child: recipeDesc, left: 10, right: 10)
        
        recipePgPct = T2()
        recipePgPct.placeholder = "Recipe PG%"
        recipePgPct.font = RobotoFont.regularWithSize(14)
        recipePgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipePgPct)
        MaterialLayout.size(recipeInfo, child: recipePgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipePgPct, left: 10)
        MaterialLayout.alignFromTop(recipeInfo, child: recipePgPct, top: 130)
        
        recipeVgPct = T2()
        recipeVgPct.placeholder = "Recipe VG%"
        recipeVgPct.font = RobotoFont.regularWithSize(14)
        recipeVgPct.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeVgPct)
        MaterialLayout.size(recipeInfo, child: recipeVgPct, width: 80, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeVgPct, left: 100)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeVgPct, top: 130)
        
        recipeSteepDays = T2()
        recipeSteepDays.placeholder = "Days to Steep"
        recipeSteepDays.font = RobotoFont.regularWithSize(14)
        recipeSteepDays.clearButtonMode = .WhileEditing
        recipeInfo.addSubview(recipeSteepDays)
        MaterialLayout.size(recipeInfo, child: recipeSteepDays, width: 120, height: 18)
        MaterialLayout.alignFromLeft(recipeInfo, child: recipeSteepDays, left: 200)
        MaterialLayout.alignFromTop(recipeInfo, child: recipeSteepDays, top: 130)
        
        // Flavor Info
        
        let flavorInfo: MaterialView = MaterialView()
        view.addSubview(flavorInfo)
        
        MaterialLayout.alignToParentHorizontally(view, child: flavorInfo, left: 14, right: 14)
        MaterialLayout.alignToParentVertically(view, child: flavorInfo, top: 185, bottom: 49)
        
        addFlavorName = T1()
        addFlavorName.placeholder = "Flavor Name"
        addFlavorName.font = RobotoFont.regularWithSize(20)
        addFlavorName.clearButtonMode = .WhileEditing
        addFlavorName.delegate = self
        flavorInfo.addSubview(addFlavorName)
        MaterialLayout.height(flavorInfo, child: addFlavorName, height: 22)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorName, top: 22)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorName, left: 10, right: 10)
        
        addFlavorPct = T2()
        addFlavorPct.placeholder = "%"
        addFlavorPct.font = RobotoFont.regularWithSize(18)
        addFlavorPct.clearButtonMode = .WhileEditing
        addFlavorPct.delegate = self
        flavorInfo.addSubview(addFlavorPct)
        MaterialLayout.size(flavorInfo, child: addFlavorPct, width: 50, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: addFlavorPct, left: 10)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorPct, top: 70)
        
        
        let flavorBaseLabel: L1 = L1()
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
        
        addFlavorButton = B2()
        addFlavorButton.setTitle("Add Flavor", forState: .Normal)
        addFlavorButton.setTitleColor(colors.dark, forState: .Normal)
        addFlavorButton.addTarget(self, action: #selector(addFlavor), forControlEvents: .TouchUpInside)
        flavorInfo.addSubview(addFlavorButton)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorButton, left: 30, right: 30)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorButton, top: 100)
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        flavorInfo.addSubview(flavorTable)
        MaterialLayout.alignToParent(view, child: flavorTable, top: 175, left: 0, bottom: 0, right: 0)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        addFlavor()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        self.view.resignFirstResponder()
    }
    
    func addFlavor() {

        flavorMGR.addFlavor(addFlavorName.text!, base: addFlavorBase.selectedSegmentIndex == 0 ? "PG" : "VG", pct: addFlavorPct.text!)
        flavorTable.reloadData()
        addFlavorName.text = ""
        addFlavorBase.selectedSegmentIndex = 0
        addFlavorPct.text = ""
        
    }
    
    func sendRecipe() {
        var rdata = [String: String]()
        
        rdata["recipeName"] = recipeName.text
        rdata["creator"] = AppState.sharedInstance.displayName
        rdata["recipeDesc"] = recipeDesc.text
        rdata["recipePgPct"] = recipePgPct.text
        rdata["recipeVgPct"] = recipeVgPct.text
        rdata["recipeSteepDays"] = recipeSteepDays.text
        
        // Push recipe data to myRecipes Firebase Database
        let key = Queries.myRecipes.childByAutoId().key
        Queries.myRecipes.child(key).setValue(rdata)
        
        // add flavors to the flavors db
        for flavor in flavorMGR.flavors {
            var fdata = [String:String]()
            fdata["flavorName"] = flavor.name
            fdata["flavorBase"] = flavor.base
            fdata["flavorPct"] = flavor.pct
            Queries.flavors.child(key).childByAutoId().setValue(fdata)
        }
        
        recipeName.text = ""
        recipeDesc.text = ""
        recipePgPct.text = ""
        recipeVgPct.text = ""
        recipeSteepDays.text = ""
        addFlavorName.text = ""
        addFlavorBase.selectedSegmentIndex = 0
        addFlavorPct.text = ""
        flavorMGR.reset()
        
        view.endEditing(true)
        self.view.resignFirstResponder()
        
        tabBarController?.selectedIndex = 0
    }
        
}


/// TableViewDataSource methods.
extension CreateRecipeViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavorMGR.flavors.count
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: RecipeCell = RecipeCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        let flavor = flavorMGR.flavors[indexPath.row]
        cell.textLabel?.text = flavor.name
        cell.detailTextLabel?.text = "Base: \(flavor.base), Percent of Recipe: \(flavor.pct)"
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            flavorMGR.flavors.removeAtIndex(indexPath.row)
            flavorTable.reloadData()
        }
        
    }
}

