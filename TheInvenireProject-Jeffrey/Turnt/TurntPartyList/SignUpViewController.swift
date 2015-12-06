//
//  SignUpViewController.swift
//  TurntPartyList
//
//  Created by Shaili Patel on 11/14/15.
//  Copyright © 2015 Shaili Patel. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!

    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var backToLogin: UIButton!
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    
    var name_ = ""
    var password_ = ""
    var confirmPassword_ = ""
    var email_ = ""
    var username_ = ""
    var profPic_: UIImage = UIImage()
    
    @IBAction func backToLoginButton(sender: AnyObject) {
    self.performSegueWithIdentifier("goBackToLogin", sender: self)
    }
    
    
    func displayAlert(title: String, displayError: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: {
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountButton(sender: AnyObject) {
        
        var displayError = ""
        if name.text == "" {
            displayError = "Please enter a name"
        } else if email.text == ""
        {
            displayError = "Please enter a email"
        }
        else if username.text == ""
        {
            displayError = "Please enter a username"
        }
            
        else if password.text == ""
        {
            displayError = "Please enter a password"
        }
        else if confirmPassword.text == ""
        {
            displayError = "Please confirm password"
        }
        else if confirmPassword.text != password.text
        {
            displayError = "Make sure to confirm password correctly"
        }
        
        if displayError != ""
        {
            displayAlert("Incomplete form", displayError: displayError)
        }
        else
        {
            name_ = name.text!
            password_ = password.text!
            confirmPassword_ = confirmPassword.text!
            email_ = email.text!
            username_ = username.text!
            profPic_ = profPic.image!
            
            let user = PFUser(className: "_User")
            user.password = password_
            user["confirmPassword"] = confirmPassword_
            user.email = email_
            user.username = username_
            user["Name"] = name_
            let profPicFile = PFFile(name: "profilePicture.png", data: UIImageJPEGRepresentation(profPic.image!, 0.5)!)
            user["profPic"] = profPicFile
            
            
            user.signUpInBackgroundWithBlock { (succeeded, signupError) -> Void in
                if signupError == nil{
                    self.performSegueWithIdentifier("goBackToLogin", sender: self)
                } else {
                    if let error = signupError!.userInfo["error"] as? NSString {
                        displayError = error as String
                    } else {
                        displayError = "Please try again later"
                    }
            }
        }
    }

    
    @IBAction func chooseImageButton(sender: AnyObject) {
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
        }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    }