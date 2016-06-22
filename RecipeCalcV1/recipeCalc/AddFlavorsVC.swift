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
    var edit: Bool = Bool()
    
    // text fields
    private var addFlavorName: T1!
    private var addFlavorBase: UISegmentedControl!
    private var addFlavorPct: T2!
    private var addFlavorButton: B2!
    
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
    
    convenience init(recipe: Recipe, edit: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
        self.edit = edit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavigationItem()
        prepareTextFields()
        configureDatabase()
    }
    
    func configureDatabase() {
        if edit {
            _refHandle = Queries.flavors.child(recipe.key).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
                let key = snapshot.key as String
                let name = snapshot.value!["name"] as! String
                let pct = snapshot.value!["pct"] as! String
                let base = snapshot.value!["base"] as! String
                self.flavorMGR.addFlavor(Flavor(name: name, base: base, pct: pct, key: key))
                self.flavorTable.reloadData()
            })
        }
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Create"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(sendRecipe))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    func prepareTextFields() {
        
        // Flavor Info
        
        let flavorInfo: MaterialView = MaterialView()
        view.addSubview(flavorInfo)
        view.layout(flavorInfo).top(10).bottom(49).left(8).right(8)
        
        addFlavorName = T1()
        addFlavorName.placeholder = "Flavor Name"
        addFlavorName.errorCheck = true
        addFlavorName.errorCheckFor = "text"
        addFlavorName.textLength = 3
        addFlavorName.clearButtonMode = .WhileEditing
        addFlavorName.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorName.delegate = self
        
        addFlavorPct = T2()
        addFlavorPct.placeholder = "%"
        addFlavorPct.clearButtonMode = .WhileEditing
        addFlavorPct.addTarget(self, action: #selector(self.errorCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorPct.errorCheck = true
        addFlavorPct.errorCheckFor = "number"
        addFlavorPct.numberMax = 100
        addFlavorPct.delegate = self
        
        let flavorBaseLabel: L3 = L3()
        flavorBaseLabel.text = "Flavor base"
            
        addFlavorBase = UISegmentedControl(items: ["PG","VG"])
        addFlavorBase.selectedSegmentIndex = 0
        
        addFlavorButton = B2()
        addFlavorButton.height = 30
        addFlavorButton.setTitle("Add Flavor", forState: .Normal)
        addFlavorButton.setTitleColor(colors.dark, forState: .Normal)
        addFlavorButton.addTarget(self, action: #selector(addFlavor), forControlEvents: .TouchUpInside)
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        let children = [addFlavorName, addFlavorPct, flavorBaseLabel, addFlavorBase, addFlavorButton]
        var dist = 10
        let spacing = 60
        for child in children {
            flavorInfo.layout(child).top(CGFloat(dist)).horizontally(left: 10, right: 10)
            dist += dist < 80 || dist > 130 ? spacing : 20
        }
        
        flavorInfo.layout(flavorTable).top(270).bottom(-40).horizontally(left: 10, right: 10)
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
        
        if edit {
            navigationController?.popToRootViewControllerAnimated(true)
        } else {
            tabBarController?.selectedIndex = 0
        }
    }
    
    func errorCheck(field: myTextField) {
        if field.errorCheck {
            
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
            
            if self.recipe != nil && self.recipe.key != "" && flavorMGR.flavors[indexPath.row].key != "" {
                Queries.flavors.child(self.recipe.key).child(flavorMGR.flavors[indexPath.row].key).setValue(nil)
            }
            
            flavorMGR.flavors.removeAtIndex(indexPath.row)
            flavorTable.reloadData()
        }
        
    }
}

