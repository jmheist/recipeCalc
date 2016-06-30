//
//  MixPrepVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/8/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material

class NotesVC: UIViewController {
    
    var recipe: Recipe!
    var noteView: TextView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }
    
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavigationItem()
        prepareNotes()
    }
    
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = "Notes"
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveNote))
        navigationItem.rightBarButtonItems = [saveButton]
    }
    
    func prepareNotes() {
        
        Queries.notes.child(recipe.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
           self.noteView.text = snapshot.value!.isKindOfClass(NSNull) ? "" : snapshot.value as! String
        })
        
        let noteLabel: L2 = L2()
        noteLabel.text = "\(recipe.name)\nnotes"
        noteLabel.textAlignment = .Center
        view.layout(noteLabel).top(10).center()
        
        noteView = TextView()
        view.layout(noteView).top(70).bottom(250).left(14).right(14)
        
    }
    
    func saveNote() {
        Queries.notes.child(recipe.key).setValue(noteView.text)
        navigationController?.popViewControllerAnimated(true)
    }
    
}
