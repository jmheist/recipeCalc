//
//  StorageManager.swift
//  recipeCalc
//
//  Created by Jacob Heisterkamp on 7/6/16.
//  Copyright © 2016 Vape&Prosper. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
import Photos


let storageMgr: StorageManager = StorageManager()
let storage = FIRStorage.storage()
let storageRef = storage.referenceForURL("gs://socialvape-36759.appspot.com")
let profileImagesRef = storageRef.child("profile_images")

class StorageManager: NSObject {
    
    func storeFBImage(user: FIRUser, completionHandler:(String)->()) {
        
        let profileImage = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":100, "width": 100, "redirect":false], HTTPMethod: "GET")
        profileImage.startWithCompletionHandler({(connection, result, error) -> Void in
            if error == nil {
                let dict = result as? NSDictionary
                let data = dict?.objectForKey("data")
                let urlPic = (data?.objectForKey("url"))! as! String
                
                if let data = NSData(contentsOfURL: NSURL(string: urlPic)!) {
                    let picRef = profileImagesRef.child(user.uid+".jpg")
                    picRef.putData(data, metadata: nil) {
                        metadata, error in
                        
                        if error == nil {
                            print(picRef.fullPath)
                            completionHandler(picRef.fullPath)
                        } else {
                            print("Error Downloading Image")
                        }
                        
                    }
                }
            } else {
                print("Error Getting FB Image", error)
            }
        })
    }
    
    func getProfilePic(userId: String, completionHandler:(image: UIImage)->()) {
        
        // Create a reference to the file you want to download
        let profileImage = profileImagesRef.child(userId+".jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        profileImage.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
            if (error != nil) {
                print("error downloading profile pic, doesn't exist?")
                // return the default profile image, trekky...
                let image = UIImage(named: "star_trek_gesture-accent")
                completionHandler(image: image!)
            } else {
                // ... let islandImage: UIImage! = UIImage(data: data!)
                completionHandler(image: UIImage(data: data!)!)
            }
        }
        
    }
    
    func saveProfileImage(asset: PHAsset, uid: String, completionHandler:(image: UIImage, imageFound: Bool)->()) {
        
        let options = PHImageRequestOptions()
        options.synchronous = false
        options.resizeMode = .Fast
        options.deliveryMode = .HighQualityFormat
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: 100, height: 100), contentMode: .AspectFill, options: options, resultHandler: { (image, _) -> Void in
            
            let data: NSData = UIImagePNGRepresentation(image!)!
            
            let picRef = profileImagesRef.child(uid+".jpg")
            picRef.putData(data, metadata: nil) {
                metadata, error in
                
                if error == nil {
                    print("image uploaded to firebase: sucess")
                } else {
                    print("Error Downloading Image")
                }
                
            }
            
            completionHandler(image: image!, imageFound: true)
        })
        
    }
    
}
