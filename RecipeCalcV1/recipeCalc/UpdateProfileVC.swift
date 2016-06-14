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

class UpdateProfileVC: UIViewController, TextDelegate {
    
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
        hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareNavigationItem()
        prepareTextFields()
    }
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor = colors.background
    }
    
    /// Prepares the navigationItem.
    private func prepareNavigationItem() {
        navigationItem.title = "Update Your Profile"
    }
    
    func prepareTextFields() {
        
        // recipe info view
        
        let userInfo: MaterialView = MaterialView()
        view.addSubview(userInfo)
        
        Layout.height(view, child: userInfo, height: 340)
        Layout.top(view, child: userInfo, top: 0)
        Layout.horizontally(view, child: userInfo, left: 14, right: 14)
        
        // recipe info fields
        
        userName = T1()
        userName.placeholder = "Username"
        userName.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userName)
        Layout.height(userInfo, child: userName, height: 28)
        Layout.top(userInfo, child: userName, top: 25)
        Layout.horizontally(userInfo, child: userName, left: 10, right: 10)

        userEmail = T1()
        userEmail.placeholder = "Email Addesss"
        userEmail.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userEmail)
        Layout.height(userInfo, child: userEmail, height: 28)
        Layout.top(userInfo, child: userEmail, top: 85)
        Layout.horizontally(userInfo, child: userEmail, left: 10, right: 10)
        
        userCity = T1()
        userCity.placeholder = "City"
        userCity.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userCity)
        Layout.height(userInfo, child: userCity, height: 28)
        Layout.top(userInfo, child: userCity, top: 145)
        Layout.horizontally(userInfo, child: userCity, left: 10, right: 10)
        
        userState = T1()
        userState.placeholder = "State"
        userState.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userState)
        Layout.height(userInfo, child: userState, height: 28)
        Layout.top(userInfo, child: userState, top: 205)
        Layout.horizontally(userInfo, child: userState, left: 10, right: 10)
        
        userCountry = T1()
        userCountry.placeholder = "Country"
        userCountry.font = RobotoFont.regularWithSize(24)
        userInfo.addSubview(userCountry)
        Layout.height(userInfo, child: userCountry, height: 28)
        Layout.top(userInfo, child: userCountry, top: 265)
        Layout.horizontally(userInfo, child: userCountry, left: 10, right: 10)
        
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
        userBio.placeholderLabel!.textColor = colors.dark
        userBio.placeholderLabel!.text = "Description"
        
        userBio.titleLabel = UILabel()
        userBio.titleLabel!.font = RobotoFont.mediumWithSize(16)
        userBio.titleLabelColor = colors.dark
        userBio.titleLabelActiveColor = colors.dark
        
        userInfo.addSubview(userBio)
        Layout.height(userInfo, child: userBio, height: 90)
        Layout.top(userInfo, child: userBio, top: 335)
        Layout.horizontally(userInfo, child: userBio, left: 10, right: 10)
        

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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
}
