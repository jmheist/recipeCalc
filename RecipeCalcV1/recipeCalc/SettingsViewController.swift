//
//  SettingsViewController.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 5/25/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import Material

class SettingsViewController: UIViewController, TextDelegate {
    
    private var userName: T1!
    private var userEmail: T1!
    private var userCity: T1!
    private var userState: T1!
    private var userCountry: T1!
    private var userBio: TextView!
    private var userBioText: Text = Text()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        prepareTabBarItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareTitlebar()
        prepareButtons()
        prepareTextFields()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    func prepareButtons() {
        let btn: FlatButton = FlatButton()
        btn.addTarget(self, action: #selector(signOut), forControlEvents: .TouchUpInside)
        btn.setTitle("Signout", forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Normal)
        btn.setTitleColor(MaterialColor.blue.base, forState: .Highlighted)
        view.addSubview(btn)
        
        MaterialLayout.alignFromTop(view, child: btn, top: 60)
        MaterialLayout.alignToParentHorizontally(view, child: btn, left: 40, right: 40)
    }
    
    /// Prepare tabBarItem.
    private func prepareTabBarItem() {
        tabBarItem.title = "Settings"
        tabBarItem.image = MaterialIcon.settings
        tabBarItem.setTitleColor(MaterialColor.grey.base, forState: .Normal)
        tabBarItem.setTitleColor(MaterialColor.teal.base, forState: .Selected)
    }
    
    func prepareTitlebar() {
        let titleBar: MaterialView = MaterialView()
        let titleBarTitle: UILabel = UILabel()
        
        titleBar.backgroundColor = colors.medGrey
        
        view.addSubview(titleBar)
        MaterialLayout.height(view, child: titleBar, height: 60)
        MaterialLayout.alignToParentHorizontally(view, child: titleBar, left: -14, right: -14)
        
        titleBarTitle.text = "Settings"
        titleBarTitle.textAlignment = .Center
        
        titleBar.addSubview(titleBarTitle)
        MaterialLayout.alignToParent(titleBar, child: titleBarTitle, top: 20, left: 30, right: 30)
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let userInfo: MaterialView = MaterialView()
        userInfo.backgroundColor = colors.lightGrey
        view.addSubview(userInfo)
        
        MaterialLayout.height(view, child: userInfo, height: 340)
        MaterialLayout.alignFromTop(view, child: userInfo, top: 105)
        MaterialLayout.alignToParentHorizontally(view, child: userInfo, left: 14, right: 14)
        
        // recipe info fields
        
        userName = T1()
        userName.placeholder = "Username"
        userName.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userName)
        MaterialLayout.height(userInfo, child: userName, height: 28)
        MaterialLayout.alignFromTop(userInfo, child: userName, top: 25)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userName, left: 10, right: 10)

        userEmail = T1()
        userEmail.placeholder = "Email Addesss"
        userEmail.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userEmail)
        MaterialLayout.height(userInfo, child: userEmail, height: 28)
        MaterialLayout.alignFromTop(userInfo, child: userEmail, top: 85)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userEmail, left: 10, right: 10)
        
        userCity = T1()
        userCity.placeholder = "City"
        userCity.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userCity)
        MaterialLayout.height(userInfo, child: userCity, height: 28)
        MaterialLayout.alignFromTop(userInfo, child: userCity, top: 145)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userCity, left: 10, right: 10)
        
        userState = T1()
        userState.placeholder = "State"
        userState.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userState)
        MaterialLayout.height(userInfo, child: userState, height: 28)
        MaterialLayout.alignFromTop(userInfo, child: userState, top: 205)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userState, left: 10, right: 10)
        
        userCountry = T1()
        userCountry.placeholder = "Country"
        userCountry.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userCountry)
        MaterialLayout.height(userInfo, child: userCountry, height: 28)
        MaterialLayout.alignFromTop(userInfo, child: userCountry, top: 265)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userCountry, left: 10, right: 10)
        
        ///// Start the crazy textview stuff
        
        userBio = TextView()
        
        let layoutManager: NSLayoutManager = NSLayoutManager()
        let textContainer: NSTextContainer = NSTextContainer(size: view.bounds.size)
        layoutManager.addTextContainer(textContainer)
        
        userBioText.delegate = self
        userBioText.textStorage.addLayoutManager(layoutManager)
        
        userBio = TextView(textContainer: textContainer)
        userBio.font = RobotoFont.regular
        
        userBio.placeholderLabel = UILabel()
        userBio.placeholderLabel!.textColor = MaterialColor.black
        userBio.placeholderLabel!.text = "Description"
        
        userBio.titleLabel = UILabel()
        userBio.titleLabel!.font = RobotoFont.mediumWithSize(16)
        userBio.titleLabelColor = MaterialColor.black
        userBio.titleLabelActiveColor = MaterialColor.black
        
        userInfo.addSubview(userBio)
        MaterialLayout.height(userInfo, child: userBio, height: 90)
        MaterialLayout.alignFromTop(userInfo, child: userBio, top: 335)
        MaterialLayout.alignToParentHorizontally(userInfo, child: userBio, left: 10, right: 10)
        

        /**
         When changes in the textView text are made, this delegation method
         is executed with the added text string and range.
         */
        func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange) {
            textStorage.removeAttribute(NSFontAttributeName, range: range)
            textStorage.addAttribute(NSFontAttributeName, value: RobotoFont.regular, range: range)
        }
        
        /**
         When a match is detected within the textView text, this delegation
         method is executed with the added text string and range.
         */
        func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
            textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: result!.range)
        }
        
        ///// END the crazy textview stuff
    }
    
    func signOut(sender: UIButton) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            print("signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError)")
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
}
