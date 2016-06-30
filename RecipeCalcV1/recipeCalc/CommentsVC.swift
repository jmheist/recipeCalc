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

class CommentsVC: UIViewController, GADBannerViewDelegate, UITextFieldDelegate {
    
    // VARS
    var commentsTable: UITableView!
    var comments: [Comment] = []
    var recipe: Recipe!
    
    var commentField: TView!
    
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
        prepareNavigationItem()
        prepareTableView()
        prepareTextField()
        prepareAds()
    }
    
    override func viewDidAppear(animated: Bool) {
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
        registerMyClass()
        commentsTable.dataSource = self
        commentsTable.delegate = self
        
        view.layout(commentsTable).top(0).left(0).right(0).bottom(160)
        
    }
    
    func prepareTextField() {
        
        let commentingView: MaterialView = MaterialView()
        view.layout(commentingView).bottom(50).height(100).left(0).right(0)
        
        let commentLabel: L2 = L2()
        commentLabel.text = "leave a comment"
        commentLabel.textAlignment = .Center
        commentingView.layout(commentLabel).top(0).height(20).left().right()
        
        commentField = TView()
        commentField.placeholderText = "leave a comment"
        commentingView.layout(commentField).bottom(0).top(26).left(0).right(60)
        
        let send: B2 = B2()
        send.setTitle("Send", forState: .Normal)
        send.addTarget(self, action: #selector(leaveComment), forControlEvents: .TouchUpInside)
        commentingView.layout(send).right(4).width(50).centerVertically()
        
    }
    
    func prepareAds() {
        let bannerAd: GADBannerView = GADBannerView()
        view.layout(bannerAd).height(50).width(320).bottom(0).centerHorizontally()
        
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerAd.delegate = self
        bannerAd.adUnitID = adConstants.AdMobAdUnitID
        bannerAd.rootViewController = self
        bannerAd.loadRequest(request)
        
    }
    
    func leaveComment() {
        commentMgr.addComment(recipe.key, comment: Comment(author: AppState.sharedInstance.uid!, comment: commentField.text), completion: { (comments) in
            self.comments = comments
            self.commentsTable.reloadData()
        })
    }
    
    func registerMyClass() {
        commentsTable.registerClass(MaterialTableViewCell.self, forCellReuseIdentifier: "commentCell")
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
        
        cell.author.text = comment.author
        cell.comment.text = comment.comment
        
        return cell
    }
}

/// UITableViewDelegate methods.
extension CommentsVC: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 96
    }
    
}
