//
//  TextFields.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class myTextField: TextField { // creating a new root textview with errorchecl added
    
    /// Controls the visibility of detailLabel
    @IBInspectable internal var revealError: Bool = false {
        didSet {
            detailLabel.hidden = !revealError
        }
    }
    
    // errorcheck is use to hold a label for what to error check for
    
    // adding fields for errors
    var errorCheck: Bool = false
    var errorCheckFor: String = ""
    var textLength: Int = 0
    
    
    override func prepareView() {
        super.prepareView()
        
        //error stuff
        revealError = false
    }
}

class T1: myTextField {
    
    override func prepareView() {
        super.prepareView()
        super.placeholder = nil
        masksToBounds = false
        borderStyle = .None
        backgroundColor = nil
        textColor = colors.dark
        font = RobotoFont.regularWithSize(16)
        contentScaleFactor = MaterialDevice.scale
        clearButtonMode = .WhileEditing
        prepareDivider()
        preparePlaceholderLabel()
        prepareDetailLabel()
        prepareTargetHandlers()
    }
    
    /// Prepares the divider.
    private func prepareDivider() {
        dividerColor = colors.dark
        dividerActiveColor = colors.dark
        layer.addSublayer(divider)
    }
    
    /// Prepares the placeholderLabel.
    private func preparePlaceholderLabel() {
        placeholderColor = colors.dark
        placeholderActiveColor = colors.dark
        addSubview(placeholderLabel)
    }
    
    /// Prepares the detailLabel.
    private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regularWithSize(12)
        detailColor = colors.dark
        addSubview(detailLabel)
    }
    
    /// Prepares the target handlers.
    private func prepareTargetHandlers() {
        addTarget(self, action: #selector(handleEditingDidBegin), forControlEvents: .EditingDidBegin)
        addTarget(self, action: #selector(handleEditingDidEnd), forControlEvents: .EditingDidEnd)
    }
}

class T2: T1 {
    override func prepareView() {
        super.prepareView()
        font = RobotoFont.regularWithSize(14)
    }
}

class T3: myTextField {
}

class TView: TextView {
    internal override func prepareView() {
        super.prepareView()
        contentScaleFactor = MaterialDevice.scale
        textContainerInset = MaterialEdgeInsetToValue(.None)
        backgroundColor = colors.background
        borderColor = colors.dark
        borderWidth = 1
        cornerRadiusPreset = .Radius3
        titleLabelColor = colors.dark
        titleLabelActiveColor = colors.dark
        masksToBounds = false
    }
}
