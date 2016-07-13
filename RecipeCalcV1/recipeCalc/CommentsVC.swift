//
//  CommentsVC.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 6/30/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Material
import GoogleMobileAds
import IQKeyboardManagerSwift

class CommentsVC: UIViewController, GADBannerViewDelegate, UITextFieldDelegate, TextDelegate, TextViewDelegate {
    
    // VARS
    var commentsTable: UITableView!
    var comments: [Comment] = []
    var recipe: Recipe!
    
    let errorMgr: ErrorManager = ErrorManager()
    
    var commentField: TView!
    var commentLabel: L2!
    let text: Text = Text()
    var didSendComment: Bool = false
    
    //
    // bottom nav setup
    //
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
        configureDatabase()
        prepareView()
        prepareTableView()
        prepareTextField()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
        prepareNavigationItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.commentsTable.reloadData()
    }
    
    func configureDatabase() {
        commentMgr.getComments(recipe.key) { (comments) in
            self.comments = comments
            self.commentsTable.reloadData()
        }
    }
    
    /// General preparation statements.
    func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    func prepareNavigationItem() {
        navigationItem.title = "Comments"
    }
    
    /// Prepare table
    func prepareTableView() {
        
        commentsTable = UITableView()
        commentsTable.rowHeight = UITableViewAutomaticDimension
        commentsTable.estimatedRowHeight = 80
        registerMyClass()
        commentsTable.dataSource = self
        
        view.layout(commentsTable).top(0).left(0).right(0).bottom(160)
        
    }
    
    func prepareTextField() {
        
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        text.delegate = self
        text.textStorage.addLayoutManager(layoutManager)
        
        let commentingView: MaterialView = MaterialView()
        view.layout(commentingView).bottom(50).height(100).left(0).right(0)
        
        commentLabel = L2()
        commentLabel.text = "leave a comment"
        commentLabel.textAlignment = .Center
        commentingView.layout(commentLabel).top(0).height(20).left().right()
        
        commentField = TView(textContainer: textContainer)
        commentField.errorCheck = true
        commentField.maxLength = 120
        commentField.placeholderText = "leave a comment"
        commentingView.layout(commentField).bottom(0).top(26).left(0).right(70)
        
        let send: B2 = B2()
        send.setTitle("Send", forState: .Normal)
        send.titleLabel?.font = RobotoFont.lightWithSize(12)
        send.addTarget(self, action: #selector(leaveComment), forControlEvents: .TouchUpInside)
        commentingView.layout(send).right(4).width(70).centerVertically()
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(0).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = adConstants.testDevices
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.comments
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
    func leaveComment() {
        if !checkForErrors(commentField) {
            commentMgr.addComment(recipe.key, comment: Comment(authorUid: AppState.sharedInstance.signedInUser.uid!, comment: commentField.text), completion: { (comments) in
                self.didSendComment = true
                self.commentField.text = ""
                self.view.endEditing(true)
                self.view.resignFirstResponder()
                self.comments = comments
                analyticsMgr.sendCommentMade()
                self.commentsTable.reloadData()
            })
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.commentLabel.text = "leave a comment"
    }
    
    func checkForErrors(sender: TView) -> Bool {
        errorMgr.errorCheck(textview: sender, errorLabel: commentLabel)
        return errorMgr.hasErrors()
    }
    
    func registerMyClass() {
        commentsTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "commentCell")
    }
    
    
    /**
     When changes in the textView text are made, this delegation method
     is executed with the added text string and range.
     */
    func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
        if !didSendComment {
            textStorage.removeAttribute(NSFontAttributeName, range: range)
            textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
            checkForErrors(commentField)
        } else {
            didSendComment = false
        }
    }
    
    /**
     When a match is detected within the textView text, this delegation
     method is executed with the added text string and range.
     */
    func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
        textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: result!.range)
    }    
}

/// UITableViewDelegate methods.
extension CommentsVC: UITableViewDataSource {
    // UITableViewDataSource protocol methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Dequeue cell
        let cell: CommentCell = CommentCell(style: .Default, reuseIdentifier: "commentCell")
        
        let comment = comments[indexPath.row]
        
        UserMgr.getUserByKey(comment.authorUid) { (user) in
            cell.author.text = user.username
        }
        
        cell.comment.text = comment.comment
        
        return cell
    }
}