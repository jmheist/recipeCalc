
//        let biotap = UITapGestureRecognizer(target: self, action: #selector(self.showBioAlert(_:)))
//        bio.addGestureRecognizer(biotap)
//        bio.userInteractionEnabled = true


//    func showBioAlert(sender: AnyObject) {
//        let alertController = UIAlertController(title: "Update Your Bio \n\n\n\n\n\n\n", message: "", preferredStyle: .Alert)
//
//        let rect        = CGRectMake(15, 50, 240, 150.0)
//        let textView    = UITextView(frame: rect)
//
//        textView.font               = UIFont(name: "Helvetica", size: 15)
//        textView.textColor          = UIColor.lightGrayColor()
//        textView.backgroundColor    = UIColor.whiteColor()
//        textView.layer.borderColor  = UIColor.lightGrayColor().CGColor
//        textView.layer.borderWidth  = 1.0
//        textView.text               = "Enter message here"
//        textView.delegate           = self
//
//        alertController.view.addSubview(textView)
//
//        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//        let action = UIAlertAction(title: "Ok", style: .Default, handler: { action in
//
//            let msg = (textView.textColor == UIColor.lightGrayColor()) ? "" : textView.text
//
//            AppState.sharedInstance.bio = msg
//            UserMgr.sendDataToFirebase(AppState.sharedInstance.uid!, key: "bio", value: msg)
//            self.bio.text = AppState.sharedInstance.bio == "" ? "Add a Bio" : AppState.sharedInstance.bio
//
//        })
//        alertController.addAction(cancel)
//        alertController.addAction(action)
//
//        self.presentViewController(alertController, animated: true, completion: {})
//
//    }