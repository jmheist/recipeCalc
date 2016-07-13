//
//  AlertManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 7/13/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import MRConfirmationAlertView

let alertMgr: AlertManager = AlertManager()

class AlertManager: NSObject {
    
    func alertWithOptions(title: String, message: String, cancelBtn: String, conFirmBtn: String, completionHanlder:(confirmed: Bool)->()) {
        MRConfirmationAlertView.showWithTitle("Delete", message: "Are you sure you want to \n delete this recipe?", cancelButton: "Cancel", confirmButton: "Delete", completion: {(confirmed: Bool) -> Void in
            if confirmed {
                completionHanlder(confirmed: true)
            }
            else {
                completionHanlder(confirmed: false)
            }
        })
    }
    
    func alert(title: String, message: String) {
        MRConfirmationAlertView.showWithTitle(title, message: message)
    }
    
}
