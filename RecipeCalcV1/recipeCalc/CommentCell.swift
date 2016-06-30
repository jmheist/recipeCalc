//
//  CommentCell.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/30/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class CommentCell: MaterialTableViewCell {

    var author: L1 = L1()
    var comment: L1 = L1()
    
    override func prepareView() {
        super.prepareView()
        
        let cellView: MaterialView = MaterialView()
        cellView.backgroundColor = MaterialColor.clear
        contentView.layout(cellView).top(8).left(8).bottom(8).right(8)
        
        comment.numberOfLines = 3
        comment.wrapped = true
        
        cellView.layout(author).top(0).left(0).right(0).height(20)
        cellView.layout(comment).top(26).left(0).right(0).height(60)
        
    }

    
}
