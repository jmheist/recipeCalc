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
    private var origLabelText = ""
    
    // runs the error checker, and then modifies the fields to show the errors
    func errorCheck(field: myTextField?=nil, textview: TView?=nil, errorLabel: MaterialLabel?=nil) {
        
        if (field != nil) {
        
            if field!.errorCheck {
                
                self.checkForErrors(field!.text!, // data:
                    placeholder: field!.placeholder!,
                    checkFor: Check(
                        type: field!.errorCheckFor,
                        length: field!.textLength,
                        numberMax: field!.numberMax
                    ), completionHandler: { (res:ErrorResponse) in
                        if res.error {
                            print(res)
                            field!.detail = res.errorMessage
                            field!.revealError = true
                            field!.detailColor = colors.error
                            field!.dividerColor = colors.error
                        } else {
                            field!.revealError = false
                            field!.detailColor = colors.dark
                            field!.dividerColor = colors.dark
                        }
                })
            }
        }
        
        if (textview != nil) {
            
            if textview!.errorCheck {
                
                textview!.text = textview!.text.stringByReplacingOccurrencesOfString("  ", withString: " ")
                
                var error: Bool = false
                var errorMessage = ""
                
                if errorLabel != nil && origLabelText.characters.count == 0 {
                    origLabelText = (errorLabel?.text!)!
                }
                
                if textview?.maxLength > 0 && textview!.text.characters.count > textview?.maxLength {
                    error = true
                    errorMessage = "Comment is too long (-\(textview!.text.characters.count - (textview?.maxLength)!))"
                }
                
                if textview!.text.characters.count < textview?.minLength {
                    error = true
                    errorMessage = "Comment is too short"
                }
                
                if error {
                    if errors.indexOf("TextView") < 0 {
                        errors.append("TextView")
                    }
                    if (errorLabel != nil) {
                        errorLabel?.text = errorMessage
                        errorLabel?.textColor = colors.error
                    }
                } else {
                    if errors.indexOf("TextView") > -1 {
                        errors.removeAtIndex(errors.indexOf("TextView")!)
                    }
                    if (errorLabel != nil) {
                        errorLabel?.text = origLabelText
                        errorLabel?.textColor = colors.text
                    }
                }
                
            }
            
        }
    }
    
    // does the actual error checking
    func checkForErrors(data: String, placeholder: String, checkFor: Check, completionHandler:(ErrorResponse)->()) {
        
        var error: Bool = false
        var errorMessage = ""
        
        let data = data.stringByReplacingOccurrencesOfString("  ", withString: " ")
        
        func returnError() {
            if error {
                if self.errors.indexOf(placeholder) < 0 {
                    self.errors.append(placeholder)
                }
            } else {
                while self.errors.indexOf(placeholder) != -1 && self.errors.indexOf(placeholder) != nil {
                    self.errors.removeAtIndex(self.errors.indexOf(placeholder)!)
                }
            }
            
            completionHandler(ErrorResponse(error: error, errorMessage: errorMessage))
        }
        
        switch checkFor.type { // start switch
        case "text":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
                returnError()
            }
            
            returnError()
            
        case "number":
            
            let num = Float(data)
            if num == nil {
                error = true
                errorMessage = "Must be a number"
                returnError()
            }
            if num > Float(checkFor.numberMax) {
                error = true
                errorMessage = "Must be between \(checkFor.numberMax) and 0"
                returnError()
            }
            if num < Float(0) {
                error = true
                errorMessage = "Must be between \(checkFor.numberMax) and 0"
                returnError()
            }
            
            returnError()
            
        case "username":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
                returnError()
            }
            
            UserMgr.getUserByUsername(data, completionHandler: { (user:User) in
                if data.lowercaseString == user.username!.lowercaseString {
                    error = true
                    errorMessage = "Username is already taken"
                    print(error, errorMessage)
                    returnError()
                }
            })
            
            returnError()
            
        case "email":
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluateWithObject(data)
            if !result {
                error = true
                errorMessage = "Please use a valid email address"
                returnError()
            }
            
            UserMgr.getUserByEmail(data, completionHandler: { (user:User) in
                print(data == user.email)
                print(data, user.email)
                if data.lowercaseString == user.email!.lowercaseString {
                    error = true
                    errorMessage = "Email address is already taken"
                    print(error, errorMessage)
                    returnError()
                }
            })
            
            returnError()
            
        case "password":
            
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
                returnError()
            }
            
            returnError()
            
        default:
            break
        } // end switch
        
    }
    
}
