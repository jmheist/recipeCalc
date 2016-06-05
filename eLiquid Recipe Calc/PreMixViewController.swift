//
//  PreMixViewController.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/22/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit

class PreMixViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var mixAmount: UITextField!
    @IBOutlet var nicStrength: UITextField!
    @IBOutlet var nicBase: UISegmentedControl!
    @IBOutlet var nicTarget: UITextField!
    @IBOutlet var pgStandardGrams: UITextField!
    @IBOutlet var vgStandardGrams: UITextField!
    @IBOutlet var nicStandardGrams: UITextField!
    @IBOutlet var flavorStandardGrams: UITextField!
    @IBOutlet var waterStandardGrams: UITextField!
    
    @IBAction func preMixBackButton(sender: AnyObject) {
        recipeMGR.recipeToMix = 0
        performSegueWithIdentifier("preMixBackToRecipeList", sender: self)
    }
    
    @IBAction func preMixNextButton(sender: AnyObject) {
        
        let newSettings = Settings()
        
        newSettings.mixAmount = mixAmount.text!
        newSettings.nicStrength = nicStrength.text!
        newSettings.nicBase = nicBase.selectedSegmentIndex
        newSettings.nicTarget = nicTarget.text!
        newSettings.pgStandardGrams = pgStandardGrams.text!
        newSettings.vgStandardGrams = vgStandardGrams.text!
        newSettings.nicStandardGrams = nicStandardGrams.text!
        newSettings.flavorStandardGrams = flavorStandardGrams.text!
        newSettings.waterStandardGrams = waterStandardGrams.text!
        
        let recipe = realm.objects(Recipe).filter("id == \(recipeMGR.recipeToMix)").last
        recipeMGR.updateSettings(recipe!, newSettings: newSettings)
        performSegueWithIdentifier("preMixToMix", sender: self)
    }
    
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
        
//        let recipe = realm.objects(Recipe).filter("id == \(recipeMGR.recipeToMix)").last
        
        
        
    }
}
