//
//  Colors.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/31/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

let colors: Colors = Colors()

class Colors: UIColor {
    
    let light = MaterialColor.grey.lighten4
    let medium = MaterialColor.grey.base
    let dark = MaterialColor.grey.darken4
    let background = MaterialColor.white
    let textLight = MaterialColor.white
    let text = MaterialColor.grey.darken4
    let error = MaterialColor.red.darken1
    let accent = MaterialColor.amber.darken3
    let favorite = MaterialColor.red.base
    
}
