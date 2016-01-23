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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func updatePicture(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    @IBAction func confirmPic(sender: AnyObject) {
        if let currentUser = PFUser.currentUser(){
            let profPicFile = PFFile(name: "newpicture", data: UIImageJPEGRepresentation(profilePicImageView.image!, 0.5)!)
            currentUser["profPic"] = profPicFile
            currentUser.saveInBackground()
            let alert = UIAlertView(title: "Profile Picture Updated!", message: "New image has been made as your new profile picture.", delegate: self, cancelButtonTitle: "OK")
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
        let alert = UIAlertView(title: "Reset password", message: "Check email <" + currentEmail +
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
        let query = PFQuery(className:"_User")
        query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if objects != nil {
                    let imageFile = objects![0]["profPic"] as! PFFile
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
    
    func setupTitleArea() {
        titleLabel.text = "EDIT PROFILE"
        titleLabel.font = UIFont(name: "Futura", size: 25)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 100, 20, 200, 20)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.setTitle("BACK", forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        backButton.titleLabel?.adjustsFontSizeToFitWidth = true
        backButton.frame = CGRectMake(20, 20, 50, 20)
        
    }
    
    func setupEmail() {
        newEmail.backgroundColor = UIColor.clearColor()
        newEmail.attributedPlaceholder = NSAttributedString(string:"NEW EMAIL",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        newEmail.textColor = UIColor.whiteColor()
        newEmail.frame = CGRectMake(50, 100, UIScreen.mainScreen().bounds.width - 100, 30)
        
        let newEmailLine = UILabel(frame: CGRectMake(50, 132, UIScreen.mainScreen().bounds.width - 100, 1))
        newEmailLine.layer.borderWidth = 1
        newEmailLine.layer.borderColor = UIColor.whiteColor().CGColor
        view.addSubview(newEmailLine)
        
        updateEmailButton.backgroundColor = UIColor.clearColor()
        updateEmailButton.setTitle("UPDATE EMAIL", forState: .Normal)
        updateEmailButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updateEmailButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        updateEmailButton.layer.borderColor = UIColor.whiteColor().CGColor
        updateEmailButton.layer.borderWidth = 1
        updateEmailButton.frame = CGRectMake(50, 150, UIScreen.mainScreen().bounds.width - 100, 30)
        updateEmailButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func setupPassword() {
        let psswdLabel = UILabel(frame: CGRectMake(25, 220, UIScreen.mainScreen().bounds.width - 50, 25))
        psswdLabel.text = "WE WILL EMAIL YOU A LINK TO RESET YOUR PASSWORD"
        psswdLabel.font = UIFont(name: "Futura", size: 18)
        psswdLabel.textColor = UIColor.whiteColor()
        psswdLabel.backgroundColor = UIColor.clearColor()
        psswdLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(psswdLabel)
        
        updatePasswordButton.backgroundColor = UIColor.clearColor()
        updatePasswordButton.setTitle("RESET PASSWORD", forState: .Normal)
        updatePasswordButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updatePasswordButton.layer.borderColor = UIColor.whiteColor().CGColor
        updatePasswordButton.layer.borderWidth = 1
        updatePasswordButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        updatePasswordButton.frame = CGRectMake(50, 255, UIScreen.mainScreen().bounds.width - 100, 30)
        
    }
    
    func setupProfPic() {
        
        profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
        profilePicImageView.clipsToBounds = true
        profilePicImageView.layer.borderColor = UIColor.blackColor().CGColor
        profilePicImageView.layer.borderWidth = 3;
        profilePicImageView.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 62.5, 300, 125, 125)

        updateProfileButton.backgroundColor = UIColor.clearColor()
        updateProfileButton.setTitle("CHOOSE A NEW PROFILE PICTURE", forState: .Normal)
        updateProfileButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        updateProfileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        updateProfileButton.layer.borderColor = UIColor.whiteColor().CGColor
        updateProfileButton.layer.borderWidth = 1
        updateProfileButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        updateProfileButton.frame = CGRectMake(50, 460, UIScreen.mainScreen().bounds.width - 100, 30)
        updateProfileButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        confirmProfPicButton.backgroundColor = UIColor.clearColor()
        confirmProfPicButton.setTitle("UPDATE PROFILE PICTURE", forState: .Normal)
        confirmProfPicButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        confirmProfPicButton.layer.borderColor = UIColor.whiteColor().CGColor
        confirmProfPicButton.layer.borderWidth = 1
        confirmProfPicButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        confirmProfPicButton.frame = CGRectMake(50, 500, UIScreen.mainScreen().bounds.width - 100, 30)
        confirmProfPicButton.enabled = false
        confirmProfPicButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        putCurrentProfilePic()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitleArea()
        setupEmail()
        setupPassword()
        setupProfPic()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
