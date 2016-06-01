//
//  TextFields.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class T1: TextField {
    override func prepareView() {
        super.prepareView()
        super.placeholder = nil
        masksToBounds = false
        borderStyle = .None
        backgroundColor = nil
        textColor = MaterialColor.black
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
        dividerColor = MaterialColor.black
        dividerActiveColor = MaterialColor.black
        layer.addSublayer(divider)
    }
    
    /// Prepares the placeholderLabel.
    private func preparePlaceholderLabel() {
        placeholderColor = MaterialColor.black
        placeholderActiveColor = MaterialColor.black
        addSubview(placeholderLabel)
    }
    
    /// Prepares the detailLabel.
    private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regularWithSize(12)
        detailColor = MaterialColor.black
        addSubview(detailLabel)
    }
    
    /// Prepares the target handlers.
    private func prepareTargetHandlers() {
        addTarget(self, action: #selector(handleEditingDidBegin), forControlEvents: .EditingDidBegin)
        addTarget(self, action: #selector(handleEditingDidEnd), forControlEvents: .EditingDidEnd)
    }
}

class T2: TextField {
    
}

class T3: TextField {
    
}

class TView: TextView {
    internal override func prepareView() {
        super.prepareView()
        contentScaleFactor = MaterialDevice.scale
        textContainerInset = MaterialEdgeInsetToValue(.None)
        backgroundColor = MaterialColor.white
        borderColor = MaterialColor.black
        borderWidth = 1
        cornerRadiusPreset = .Radius3
        titleLabelColor = MaterialColor.black
        titleLabelActiveColor = MaterialColor.black
        masksToBounds = false
    }
}
