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

class AddFlavorsVC: UIViewController, UITextFieldDelegate {
    
    let errorMgr: ErrorManager = ErrorManager()
    var recipe: Recipe!
    
    // text fields
    private var addFlavorName: T1!
    private var addFlavorBase: UISegmentedControl!
    private var addFlavorPct: T2!
    private var addFlavorButton: B1!
    
    // flavors
    let flavorMGR: FlavorManager = FlavorManager()
    
    // nav save button
    private var saveBtn: B2!
    private var cancelBtn: B2!
    
    // table vars
    private var flavorTable: UITableView!
    let cellIdentifier = "FlavorCell"
    
    // db vars
    private var _refHandle: FIRDatabaseHandle!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Create: Flavors"
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
        
        // Flavor Info
        
        let flavorInfo: MaterialView = MaterialView()
        view.addSubview(flavorInfo)
        MaterialLayout.alignToParent(view, child: flavorInfo, top: 0, left: 0, bottom: 49, right: 0)
        
        addFlavorName = T1()
        addFlavorName.placeholder = "Flavor Name"
        addFlavorName.errorCheck = true
        addFlavorName.errorCheckFor = "text"
        addFlavorName.textLength = 3
        addFlavorName.clearButtonMode = .WhileEditing
        addFlavorName.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorName.delegate = self
        flavorInfo.addSubview(addFlavorName)
        MaterialLayout.height(flavorInfo, child: addFlavorName, height: 22)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorName, top: 30)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorName, left: 10, right: 10)
        
        addFlavorPct = T2()
        addFlavorPct.placeholder = "%"
        addFlavorPct.clearButtonMode = .WhileEditing
        addFlavorPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorPct.errorCheck = true
        addFlavorPct.errorCheckFor = "number"
        addFlavorPct.numberMax = 100
        addFlavorPct.delegate = self
        flavorInfo.addSubview(addFlavorPct)
        MaterialLayout.height(flavorInfo, child: addFlavorPct, height: 22)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorPct, top: 60)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorPct, left: 10, right: 10)
        
        
        let flavorBaseLabel: L3 = L3()
        flavorBaseLabel.text = "Flavor base"
        flavorInfo.addSubview(flavorBaseLabel)
        MaterialLayout.size(flavorInfo, child: flavorBaseLabel, width: 110, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: flavorBaseLabel, left: 10)
        MaterialLayout.alignFromTop(flavorInfo, child: flavorBaseLabel, top: 90)
        
        addFlavorBase = UISegmentedControl(items: ["PG","VG"])
        addFlavorBase.selectedSegmentIndex = 0
        flavorInfo.addSubview(addFlavorBase)
        MaterialLayout.size(flavorInfo, child: addFlavorBase, width: 80, height: 22)
        MaterialLayout.alignFromLeft(flavorInfo, child: addFlavorBase, left: 140)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorBase, top: 90)
        
        addFlavorButton = B1()
        addFlavorButton.setTitle("Add Flavor", forState: .Normal)
        addFlavorButton.setTitleColor(colors.dark, forState: .Normal)
        addFlavorButton.addTarget(self, action: #selector(addFlavor), forControlEvents: .TouchUpInside)
        flavorInfo.addSubview(addFlavorButton)
        // MaterialLayout.size(flavorInfo, child: addFlavorButton, width: 150, height: 40)
        MaterialLayout.height(flavorInfo, child: addFlavorButton, height: 40)
        MaterialLayout.alignToParentHorizontally(flavorInfo, child: addFlavorButton, left: 80, right: 80)
        MaterialLayout.alignFromTop(flavorInfo, child: addFlavorButton, top: 140)
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        // Use MaterialLayout to easily align the tableView.
        flavorInfo.addSubview(flavorTable)
        MaterialLayout.alignToParent(view, child: flavorTable, top: 195, left: 0, bottom: 0, right: 0)
        
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
        
        let fields = [addFlavorName, addFlavorPct]
        
        for field in fields {
            errorCheck(field)
        }
        
        if !errorMgr.hasErrors() { // no errors, save the flavor
            print("no errors adding flavor")
            flavorMGR.addFlavor(Flavor(name: addFlavorName.text!, base: addFlavorBase.selectedSegmentIndex == 0 ? "PG" : "VG", pct: addFlavorPct.text!))
            flavorTable.reloadData()
            addFlavorName.text = ""
            addFlavorBase.selectedSegmentIndex = 0
            addFlavorPct.text = ""
            
        }
        
    }
    
    func cancelRecipe() {
        clearForm()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func sendRecipe() {
        let key = myRecipeMgr.sendToFirebase(recipe)
        
        // add flavors to the flavors db
        flavorMGR.sendToFirebase(key, flavors: flavorMGR.flavors)
        
        clearForm() // and flavors
        
        view.endEditing(true)
        self.view.resignFirstResponder()
        
        tabBarController?.selectedIndex = 0
    }
    
    func errorCheck(field: myTextField) {
        if field.errorCheck {
            print("Checking field: '\(field.placeholder)' for errors")
            let res = errorMgr.checkForErrors(
                field.text!, // data:
                placeholder: field.placeholder!,
                checkFor: Check(
                    type: field.errorCheckFor,
                    length: field.textLength,
                    numberMax: field.numberMax
                )
            )
            if res.error {
                print("found an error with \(field)")
                field.detail = res.errorMessage
                field.revealError = true
                field.detailColor = colors.errorRed
                field.dividerColor = colors.errorRed
            } else {
                field.revealError = false
                field.detailColor = colors.dark
                field.dividerColor = colors.dark
            }
        }
    }
    
    func clearForm() {
        view.endEditing(true)
        self.view.resignFirstResponder()
        addFlavorName.text = ""
        addFlavorBase.selectedSegmentIndex = 0
        addFlavorPct.text = ""
        flavorMGR.reset()
    }
    
}


/// TableViewDataSource methods.
extension AddFlavorsVC: UITableViewDataSource {
    
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
extension AddFlavorsVC: UITableViewDelegate {
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

