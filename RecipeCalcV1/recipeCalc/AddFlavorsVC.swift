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
    var edit: Bool = Bool()
    
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
    
    convenience init(edit: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.edit = edit
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if AppState.sharedInstance.recipe == nil {
            navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTextFields()
        configureDatabase()
        prepareKeyboardHandler()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
    }
    
    func configureDatabase() {
        if edit {
            _refHandle = Queries.flavors.child(AppState.sharedInstance.recipe.key).observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
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
        view.layout(flavorInfo).top(10).bottom(49).left(8).right(8)
        
        let stepDesc: StepDescLabel = StepDescLabel()
        stepDesc.text = "Finally, add some flavors. Enter in the\nflavor name and percent, set the\nbase and click 'Add Flavor'"
        
        addFlavorName = T1()
        addFlavorName.placeholder = "Flavor Name"
        addFlavorName.errorCheck = true
        addFlavorName.errorCheckFor = "text"
        addFlavorName.textMinLength = 3
        addFlavorName.clearButtonMode = .WhileEditing
        addFlavorName.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorName.delegate = self
        
        addFlavorPct = T2()
        addFlavorPct.keyboardType = UIKeyboardType.NumbersAndPunctuation
        addFlavorPct.placeholder = "Flavor Percent (%)"
        addFlavorPct.clearButtonMode = .WhileEditing
        addFlavorPct.addTarget(self, action: #selector(self.liveCheck(_:)), forControlEvents: UIControlEvents.EditingChanged)
        addFlavorPct.errorCheck = true
        addFlavorPct.errorCheckFor = "number"
        addFlavorPct.numberMax = 100
        addFlavorPct.delegate = self
        
        let flavorBaseLabel: L3 = L3()
        flavorBaseLabel.text = "Flavor Base"
            
        addFlavorBase = UISegmentedControl(items: ["PG","VG"])
        addFlavorBase.selectedSegmentIndex = 0
        
        addFlavorButton = B1()
        addFlavorButton.height = 30
        addFlavorButton.setTitle("Add Flavor", forState: .Normal)
        addFlavorButton.setTitleColor(colors.dark, forState: .Normal)
        addFlavorButton.addTarget(self, action: #selector(btnaddFlavor), forControlEvents: .TouchUpInside)
        
        flavorTable = UITableView()
        flavorTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        flavorTable.dataSource = self
        flavorTable.delegate = self
        
        let children = [stepDesc, addFlavorName, addFlavorPct, flavorBaseLabel, addFlavorBase, addFlavorButton]
        var dist = 10
        let spacing = 80
        for child in children {
            flavorInfo.layout(child).top(CGFloat(dist)).horizontally(left: 10, right: 10)
            if child == flavorBaseLabel {
                dist += 25
            } else if child == addFlavorPct {
                dist += 50
            } else if child == addFlavorBase {
                dist += 50
            } else {
                dist += spacing
            }
        }
        
        flavorInfo.layout(flavorTable).top(350).bottom(-40).horizontally(left: 10, right: 10)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        addFlavor(true)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
        self.view.resignFirstResponder()
    }
    
    func btnaddFlavor() {
        addFlavor(true)
    }
    
    func addFlavor(reloadTable: Bool) {
        
        let fields = [addFlavorName, addFlavorPct]
        
        for field in fields {
            errorMgr.errorCheck(field)
        }
        
        if !errorMgr.hasErrors() { // no errors, save the flavor
            flavorMGR.addFlavor(Flavor(name: addFlavorName.text!, base: addFlavorBase.selectedSegmentIndex == 0 ? "PG" : "VG", pct: addFlavorPct.text!), isNewRecipe: !edit)
            addFlavorName.text = ""
            addFlavorBase.selectedSegmentIndex = 0
            addFlavorPct.text = ""
            if reloadTable {
                flavorTable.reloadData()
            }
        
        }
        
    }
    
    func cancelRecipe() {
        clearForm()
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func sendRecipe() {
        
        if addFlavorName.text != "" {
            addFlavor(false)
        }
        
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let convertedDate = dateFormatter.stringFromDate(now)
        if edit {
            AppState.sharedInstance.recipe.dateEdited = convertedDate
        } else {
            AppState.sharedInstance.recipe.dateCreated = convertedDate
        }
            
        let key = recipeMgr.sendToFirebase(AppState.sharedInstance.recipe)
        
        // add flavors to the flavors db
        flavorMGR.sendToFirebase(key, flavors: flavorMGR.flavors)
        
        clearForm() // and flavors
        AppState.sharedInstance.recipe = nil
        
        analyticsMgr.sendRecipeCreated()
        
        view.endEditing(true)
        self.view.resignFirstResponder()
        
        if edit {
            navigationController?.popToRootViewControllerAnimated(true)
        } else {
            alertMgr.alertWithOptions("Publish?", message: "Do you want to publish this recipe?\n\nIf not, you can always publish it later from the recipe page.", cancelBtn: "Later", conFirmBtn: "Publish", completionHanlder: { (confirmed) in
                if confirmed {
                    recipeMgr.publishRecipe(key, completionHandler: { (recipe) in
                        self.tabBarController?.selectedIndex = 2
                    })
                } else {
                    self.tabBarController?.selectedIndex = 2
                }
            })
        }
    }
    
    func liveCheck(field: myTextField) {
        errorMgr.errorCheck(field)
    }
    
    func clearForm() {
        view.endEditing(true)
        self.view.resignFirstResponder()
        addFlavorName.text = ""
        addFlavorBase.selectedSegmentIndex = 0
        addFlavorPct.text = ""
        flavorMGR.reset()
    }
    
    func prepareKeyboardHandler() {
        // Call this method somewhere in your view controller setup code.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        // Called when the UIKeyboardDidShowNotification is sent.
    }
    
    func keyboardWasShown(aNotification: NSNotification) {
        hideStatusBar(-20)
    }
    // Called when the UIKeyboardWillHideNotification is sent
    
    func keyboardWillBeHidden(aNotification: NSNotification) {
        showStatusBar()
    }
    
    func hideStatusBar(yOffset:CGFloat) { // -20.0 for example
        let statusBarWindow = UIApplication.sharedApplication().valueForKey("statusBarWindow") as! UIWindow
        statusBarWindow.frame = CGRectMake(0, yOffset, statusBarWindow.frame.size.width, statusBarWindow.frame.size.height)
    }
    
    func showStatusBar() {
        let statusBarWindow = UIApplication.sharedApplication().valueForKey("statusBarWindow") as! UIWindow
        statusBarWindow.frame = CGRectMake(0, 0, statusBarWindow.frame.size.width, statusBarWindow.frame.size.height)
    }
    
}


/// TableViewDataSource methods.
extension AddFlavorsVC: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flavorMGR.flavors.count
    }
    
    /// Prepares the cells within the tableView.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: MaterialTableViewCell = MaterialTableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
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
            
            if self.edit && flavorMGR.flavors[indexPath.row].key != "" {
                Queries.flavors.child(AppState.sharedInstance.recipe.key).child(flavorMGR.flavors[indexPath.row].key).setValue(nil)
            }
            
            flavorMGR.flavors.removeAtIndex(indexPath.row)
            flavorTable.reloadData()
        }
        
    }
}

