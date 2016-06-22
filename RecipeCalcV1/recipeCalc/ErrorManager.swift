//
//  ErrorManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/10/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import Firebase

struct Check {
    var type = String()
    var length: Int = 0
    var numberMax: Int = 0
    
    init(type: String, length: Int?=0, numberMax: Int?=0) {
        self.type = type
        self.length = length!
        self.numberMax = numberMax!
    }
}

struct ErrorResponse {
    var error: Bool
    var errorMessage: String
    
    init(error: Bool, errorMessage: String) {
        self.error = error
        self.errorMessage = errorMessage
    }
}

class ErrorManager: NSObject {
    
    func hasErrors() -> Bool {
        return self.errors.count > 0
    }
    
    private var errors = [String]()
    
    func checkForErrors(data: String, placeholder: String, checkFor: Check) -> ErrorResponse {
        
        var error: Bool = false
        var errorMessage = ""
        
        switch checkFor.type { // start switch
        case "text":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
            }
            
        case "number":
            
            let num = Float(data)
            if num == nil {
                error = true
                errorMessage = "Must be a number"
                
            }
            if num > Float(checkFor.numberMax) {
                error = true
                errorMessage = "Must be between \(checkFor.numberMax) and 0"
            }
            if num < Float(0) {
                error = true
                errorMessage = "Must be between \(checkFor.numberMax) and 0"
            }
            
        case "username":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
            }
            print("checking email address")
            for (key, _) in UserMgr.users {
                
                if data == UserMgr.users[key]!.username {
                    error = true
                    errorMessage = "This username is already taken"
                    break
                }
            }
            
        case "email":
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluateWithObject(data)
            if !result {
                error = true
                errorMessage = "Please use a valid email address"
            }
            
            for (key, _) in UserMgr.users {
                print("checking email address")
                if data == UserMgr.users[key]!.email {
                    error = true
                    errorMessage = "This email address is already taken"
                    break
                }
            }
            
        case "password":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
            }
            
        default:
            break
        } // end switch
        
        
        if error {
            if self.errors.indexOf(placeholder) < 0 {
                self.errors.append(placeholder)
            }
        } else {
            while self.errors.indexOf(placeholder) != -1 && self.errors.indexOf(placeholder) != nil {
                self.errors.removeAtIndex(self.errors.indexOf(placeholder)!)
            }
        }
        
        return ErrorResponse(error: error, errorMessage: errorMessage)
    }
    
    
}
