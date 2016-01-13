//
//  changeProfileVC.swift
//  Invenire
//
//  Created by Abhi on 12/5/15.
//  Copyright © 2015 Abhishek Mangla. All rights reserved.
//

import UIKit

class changeProfileVC: ViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var updateEmailButton: UIButton!
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var updateProfileButton: UIButton!
    @IBOutlet weak var confirmProfPicButton: UIButton!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var newEmail: UITextField!
    
    @IBAction func updatePicture(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    override func shouldAutorotate() -> Bool {
        if (UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeLeft ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.LandscapeRight ||
            UIDevice.currentDevice().orientation == UIDeviceOrientation.Unknown) {
                return false
        }
        else {
            return true
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait ,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    @IBAction func confirmPic(sender: AnyObject) {
        if let currentUser = PFUser.currentUser(){
            let profPicFile = PFFile(name: "newpicture", data: UIImageJPEGRepresentation(profilePicImageView.image!, 0.5)!)
            currentUser["profPic"] = profPicFile
            currentUser.saveInBackground()
            var alert = UIAlertView(title: "Profile Picture Updated!", message: "New image has been made as your new profile picture.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        confirmProfPicButton.enabled = true
        profilePicImageView.image = image // puts in image
        
    }
    
    @IBAction func changePassword(sender: AnyObject) {
        let currentEmail = PFUser.currentUser()!["email"] as! String
        PFUser.requestPasswordResetForEmailInBackground(currentEmail)
        var alert = UIAlertView(title: "Reset password", message: "Check email <" + currentEmail +
            "> to reset password.", delegate: self, cancelButtonTitle: "OK")
        alert.show()
    }
    
    @IBAction func changeEmail(sender: AnyObject) {
        if let currentUser = PFUser.currentUser(){
            if newEmail.text!.characters.count < 8 || newEmail.text!.containsString("@") == false {
                let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else {
                currentUser["email"] = newEmail.text
                currentUser.saveInBackground()
                let alert = UIAlertView(title: "Email Changed!", message: "Email successfully updated.", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        }
    }
    
    func putCurrentProfilePic() {
        //this first query deals with loading user profile image and name
        var query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects! as? [PFObject] {
                    let imageFile = objects[0]["profPic"] as! PFFile
                    imageFile.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in if error == nil {
                        let image1 = UIImage(data: imageData!)
                        self.profilePicImageView.image = image1
                        }
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        updatePasswordButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        updatePasswordButton.layer.cornerRadius = 10
        updateEmailButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        updateEmailButton.layer.cornerRadius = 10
        updateProfileButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        updateProfileButton.layer.cornerRadius = 10
        confirmProfPicButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        confirmProfPicButton.layer.cornerRadius = 10
        putCurrentProfilePic()
        confirmProfPicButton.enabled = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
