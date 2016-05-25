//
//  ViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/24/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var emailAddress: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpAction(sender: AnyObject) {
        
        if fb.registerUser(emailAddress.text!, password: password.text!) {
            performSegueWithIdentifier("showRecipeList", sender: self)
        }
        
    }
}

