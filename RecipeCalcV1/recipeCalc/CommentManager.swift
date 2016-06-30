//
//  CommentManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/30/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase

struct Comment {
    
    var author: String = ""
    var comment: String = ""
    var key: String = ""
    
    init(author: String, comment: String, key: String?="") {
        self.author = author
        self.comment = comment
    }
    
    func fb() -> AnyObject {
        var com = [String:String]()
        com["name"] = author
        com["base"] = comment
        return com
    }
    
}

class CommentManager: NSObject {
    
    func addComment(recipeId: String, comment: Comment, completion:([Comment])->()) {
        Queries.comments.child(recipeId).childByAutoId().setValue(comment.fb())
        getComments(recipeId) { (comments) in
            completion(comments)
        }
    }
    
    func getComments(recipeId: String, completion:([Comment])->()) {
        var comments: [Comment] = []
        Queries.comments.child(recipeId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                comments.append(Comment(author: child.value!["author"] as! String, comment: child.value!["comment"] as! String, key: child.key))
            }
            completion(comments)
        })
    }
    
    func deleteComment(recipeId: String, commentId: String, completion:([Comment])->()) {
        Queries.comments.child(recipeId).child(commentId).setValue(nil)
        getComments(recipeId) { (comments) in
            completion(comments)
        }
    }
    
}
