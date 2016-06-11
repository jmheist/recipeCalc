//
//  ErrorManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/10/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

struct Check {
    var type = String()
    var length: Int = 0
    
    init(type: String, length: Int?=0) {
        self.type = type
        self.length = length!
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
    
    var errors = false
    
    func checkForErrors(data: String, checkFor: Check) -> ErrorResponse {
        print("Running checkForErrors")
        var error: Bool = false
        var errorMessage = ""
        
        switch checkFor.type { // start switch
        case "text":
            print(((checkFor.length != 0) && (data.characters.count <= checkFor.length)))
            if (checkFor.length != 0) && (data.characters.count <= checkFor.length) {
                error = true
                errorMessage = "Please use more than \(checkFor.length) characters"
            }
        default:
            break
        } // end switch
        
        
        if error {
            self.errors = true
        }
        
        return ErrorResponse(error: error, errorMessage: errorMessage)
    
    }
    
    
}
