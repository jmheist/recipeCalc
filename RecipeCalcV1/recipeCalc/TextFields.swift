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
    var numberMax: Int = 0
    
    // adding fields for auto calcs, like updating pg/vg %
    var autoUpdate = false
    var autoUpdateFieldName = ""
    
    override func prepareView() {
        super.prepareView()
        
        backgroundColor = colors.light
        
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
        detailVerticalOffset = 6
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
        detailVerticalOffset = 0
    }
}

class T3: T1 {
    override func prepareView() {
        super.prepareView()
        font = RobotoFont.regularWithSize(14)
        detailVerticalOffset = 0
    }
}

class TView: TextView {
    internal override func prepareView() {
        super.prepareView()
        contentScaleFactor = MaterialDevice.scale
        textContainerInset = MaterialEdgeInsetToValue(.None)
        backgroundColor = colors.background
        borderColor = colors.light
        borderWidth = 0.7
        cornerRadiusPreset = .None
        titleLabelColor = colors.dark
        titleLabelActiveColor = colors.dark
        masksToBounds = true
        clipsToBounds = true
        font = RobotoFont.regular
        placeholderLabel = UILabel()
        placeholderLabel!.textColor = MaterialColor.grey.base
        placeholderLabel!.text = ""
        titleLabel = UILabel()
        titleLabel!.font = RobotoFont.mediumWithSize(12)
        titleLabelColor = MaterialColor.grey.base
        titleLabelActiveColor = MaterialColor.blue.accent3
    }
}