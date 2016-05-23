//
//  SecondViewController.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var recipeName: UITextField!
    @IBOutlet var recipeDesc: UITextField!
    @IBOutlet var recipePgPct: UITextField!
    @IBOutlet var recipeVgPct: UITextField!
    
    @IBOutlet var newFlavorName: UITextField!
    @IBOutlet var newFlavorBase: UISegmentedControl!
    @IBOutlet var newFlavorPct: UITextField!
    @IBOutlet var flavorTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("view will appear - 2nd page - recipeToEdit = \(recipeMGR.recipeToEdit)")
        if recipeMGR.recipeToEdit > 0 {
            
            print("loading a recipe to edit: \(recipeMGR.recipeToEdit)")
            
            // load recipe to edit
            
            let recipeToEdit = recipeMGR.getRecipeToEdit()
            
            recipeName.text = recipeToEdit.name
            recipeDesc.text = recipeToEdit.desc
            recipePgPct.text = recipeToEdit.pgPct
            recipeVgPct.text = recipeToEdit.vgPct
            
            print("editing recipe with \(recipeToEdit.flavors.count) flavors")
            
            if recipeToEdit.flavors.count > 0 {
                for flavor in recipeToEdit.flavors {
                    flavorMGR.addFlavor(flavor.name, base: flavor.base, pct: flavor.pct)
                }
                flavorTable.reloadData()
            }
        }
    }

    
    // Events
    @IBAction func saveRecipeButtonCLick(sender: AnyObject) {
        
        
        // add new recipe
        recipeMGR.addRecipe(recipeName.text!, desc: recipeDesc.text!, pgPct: recipePgPct.text!, vgPct: recipeVgPct.text!, flavors: flavorMGR.flavors, id: recipeMGR.recipeToEdit)
        
        self.view.endEditing(true)
        clearSecondView()
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func addFlavorButtonClick(sender: AnyObject) {
        print("Adding a Flavor")
        flavorMGR.addFlavor(newFlavorName.text!, base: newFlavorBase.selectedSegmentIndex, pct: newFlavorPct.text!)
        newFlavorName.text = ""
        newFlavorPct.text = ""
        flavorTable.reloadData()
        print("Flavor Added")
    }
    
    @IBAction func clearRecipeButtonClick(sender: AnyObject) {
        clearSecondView()
    }
    
    
    
    // iOS Touch Functions
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    // UITableViewDelegate Functions
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            flavorMGR.flavors.removeAtIndex(indexPath.row)
            flavorTable.reloadData()
        }
        
    }
    
    // table settings
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("checking how many flavors there are")
        return flavorMGR.flavors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("building the cells of the flavor table")
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "flavorCell")
        
        cell.textLabel?.text = flavorMGR.flavors[indexPath.row].name + " " + flavorMGR.flavors[indexPath.row].pct + "%"
        
        return cell
        
    }
    
    // Utilities
    func clearSecondView() {
        recipeDesc.text = ""
        recipeName.text = ""
        recipeVgPct.text = ""
        recipePgPct.text = ""
        newFlavorName.text = ""
        newFlavorPct.text = ""
        newFlavorBase.selectedSegmentIndex = 2
        flavorMGR.reset()
        flavorTable.reloadData()
    }

}

