//
//  SignUpViewController.swift
//  TurntPartyList
//
//  SignUpViewController.swift
//  TurntPartyList
//

//  SignUpViewController.swift

//  TurntPartyList

//

//  Created by Shaili Patel on 11/14/15.

//  Copyright © 2015 Shaili Patel, Abhishek Mangla. All rights reserved.

//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailField || textField == confirmPasswordField {
            scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
        }
        else {
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
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
    
    
    func containDB(test: String, classer: String, column: String) -> Bool {
        var num = 0
        var query = PFQuery(className: classer)
        query.whereKey(column, equalTo: test)
        do {
            let objects = try query.findObjects()
            num = objects.count
        } catch _ {
            num = 0
        }
        if num >= 1 {
            return true
        }
        else {
            return false
        }
    }
    
    
    @IBAction func createAccount(sender: AnyObject) {
        var username = self.usernameField.text
        var password = self.passwordField.text
        var email = self.emailField.text
        var finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var name = self.nameField.text
        var confirmPassword = self.confirmPasswordField.text
        
        
        // Validate the text fields
        if username!.characters.count < 5 {
            var alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if password!.characters.count < 8 {
            var alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
        } else if email!.characters.count < 8 || email!.containsString("@") == false {
            let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        } else if confirmPassword != password {
            let alert = UIAlertView(title: "Invalid", message: "Passwords do not match!", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else {
            // Run a spinner to show a task in progress
            var spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
            spinner.startAnimating()
            
            var newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            newUser["Name"] = name
            newUser["confirmPassword"] = confirmPassword
            
            if profPic.image == nil {
                let profPicFile = PFFile(name: name! + "_picture", data: UIImageJPEGRepresentation(UIImage(named: "profileIcon2.jpg")!, 0.5)!)
                newUser["profPic"] = profPicFile
            }
            else {
                let profPicFile = PFFile(name: name! + "_picture", data: UIImageJPEGRepresentation(profPic.image!, 0.5)!)
                newUser["profPic"] = profPicFile
            }
            
            // Sign up the user asynchronously
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                // Stop the spinner
                spinner.stopAnimating()
                if ((error) != nil) {
                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    
                } else {
                    var alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                    alert.show()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") as! UIViewController
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        profPic.image = image // puts in image
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        
        self.nameField.delegate = self
        self.usernameField.delegate = self
        self.passwordField.delegate = self
        self.confirmPasswordField.delegate = self
        self.emailField.delegate = self
        
        submitButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        submitButton.layer.cornerRadius = 10
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}