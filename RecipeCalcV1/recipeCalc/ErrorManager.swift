//
//  ErrorManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/10/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

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
    
    func checkForErrors(data: String, checkFor: String) -> ErrorResponse {
        print("Running checkForErrors")
        var error: Bool = false
        var errorMessage = ""
        switch checkFor {
        case "text":
            if data.characters.count < 4 {
                error = true
                errorMessage = "Please use more than 3 characters"
            }
        default:
            break
        }
        
        if error {
            self.errors = true
        }
        
        return ErrorResponse(error: error, errorMessage: errorMessage)
    
    }
    
    
}
