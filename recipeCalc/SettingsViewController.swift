//
//  SettingsViewController.swift
//  
//
//  Created by Jacob Heisterkamp on 5/24/16.
//
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func logOutAction(sender: AnyObject) {
        print("Logging User Out")
        fb.logout()
        performSegueWithIdentifier("showLogin2", sender: self)
    }
}
