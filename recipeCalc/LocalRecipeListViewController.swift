//
//  LocalRecipeListViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

class LocalRecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var recipeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TABLE SETTUP
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            print("Showing Create Recipe Cell")
        
            let cell = recipeTable.dequeueReusableCellWithIdentifier("createCell") as! CreateCell
            
            return cell
            
        } else {
            
            print("Showing Recipe Cell")
            
            let cell = recipeTable.dequeueReusableCellWithIdentifier("recipeCell") as! RecipeCell
            
            cell.name.text = "Recipe Name"
            cell.desc.text = "This is my recipe Desciption. This is my recipe Desciption. This is my recipe Desciption. This is my recipe Desciption. This is my recipe Desciption. This is my recipe Desciption."
            
            cell.desc.preferredMaxLayoutWidth = 500
            cell.desc.lineBreakMode = NSLineBreakMode.ByWordWrapping
            cell.desc.numberOfLines = 3
            
            return cell
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("cell was tapped // do something")
    }
    
    // END TABLE SETUP
    
}
