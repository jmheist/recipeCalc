//
//  FirstViewController.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var recipeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returning to View
    override func viewWillAppear(animated: Bool) {
        recipeTable.reloadData()
    }
    
    // UITableViewDelegate Functions
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            recipeMGR.removeRecipe(recipeMGR.recipes[indexPath.row])
            recipeTable.reloadData()
        }
        
    }
    
    // UIViewTableDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeMGR.recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = self.recipeTable.dequeueReusableCellWithIdentifier("recipeCell", forIndexPath: indexPath) as! RecipeListCell
        
        cell.recipeName.text = recipeMGR.recipes[indexPath.row].name
        cell.recipeDesc.text = recipeMGR.recipes[indexPath.row].desc
        
        cell.recipeEditButton.tag = indexPath.row
        cell.recipeEditButton.addTarget(self, action: #selector(FirstViewController.editRecipe(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // send selected recipe to mixing view
        recipeMGR.recipeToMix = recipeMGR.recipes[indexPath.row].id
        print("loading recipe #\(recipeMGR.recipeToMix) to mix")
        performSegueWithIdentifier("showMixSettingsView", sender: self)
        
    }

    @IBAction func editRecipe(sender: UIButton) {
        recipeMGR.recipeToEdit = recipeMGR.recipes[sender.tag].id
        print("loading the recipe ", recipeMGR.recipeToEdit)
        
        print("Trying to send to edit")
        self.tabBarController?.selectedIndex = 1
    }
    
}

