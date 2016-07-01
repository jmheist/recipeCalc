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

    var author: L2 = L2()
    var comment: L2 = L2()
    var deleteButton: UIImageView = UIImageView()
    
    override func prepareView() {
        super.prepareView()
        
        let cellView: MaterialView = MaterialView()
        cellView.backgroundColor = MaterialColor.clear
        contentView.layout(cellView).top(8).left(8).bottom(8).right(8)
        
        author.textLayer.pointSize = 14
        
        comment.textLayer.pointSize = 12
        comment.numberOfLines = 4
        comment.wrapped = true
        
        deleteButton.image = MaterialIcon.cm.clear
        deleteButton.hidden = true
        
        cellView.layout(author).top(0).left(0).right(14).height(16)
        cellView.layout(comment).top(20).left(0).right(0).height(60)
        cellView.layout(deleteButton).top(0).right(0).height(14).width(14)
        
    }
    
}
