//
//  ErrorManager.swift
//  eLiquid Recipe Calc
//
//  Created by Jacob Heisterkamp on 5/18/16.
//  Copyright (c) 2016 Vape&Prosper. All rights reserved.
//

import UIKit

struct error {
    
    var msg = ""
    var sender = ""
    
}

let errorMGR: ErrorManager = ErrorManager()

class ErrorManager: NSObject {
    
    var errors = [error]()
    
    func checkForErrors(type: String, view: UIViewController, recipe: Recipe?=nil, flavor: Flavor?=nil) -> Bool {
        // check the fields passed in for errors
        // add errors and offending fields to errors object
        
        
        if recipe != nil {
            
        }
        
        if flavor != nil {
            
        }
        
        
        
        // test errors
        var newError = error()
        newError.msg = "Error!"
        newError.sender = "The Text Field"
        var newError2 = error()
        newError2.msg = "Error1!"
        newError2.sender = "The Text Field2"
        var newError3 = error()
        newError3.msg = "Error2!"
        newError3.sender = "The Text Field2"
        
        errors.append(newError)
        errors.append(newError2)
        errors.append(newError3)
        
        if errors.count > 0 {
            showErrors(view)
            return true
        }
        
        // return false for no errors
        return false
    }
    
    func showErrors(view: UIViewController) {
        var errorMessage = ""
        
        for error in errors {
            errorMessage += (error.sender + " - " + error.msg + "\n")
        }
        
        let errorAlert = UIAlertController(
            title: "Errors",
            message: errorMessage,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let okButton = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil)
        
        errorAlert.addAction(okButton)
        
        view.presentViewController(errorAlert, animated: true, completion: finishError)
    }
    
    func finishError() {
        print("done showing errors")
        errors.removeAll()
    }
    
}


