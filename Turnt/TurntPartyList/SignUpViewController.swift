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
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var profPicImageView: UIImageView!
    
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var goToLogin: UIButton!
    
    enum UINavigationControllerOperation : Int {
        case None
        case Push
        case Pop
    }
    
    var name_ = ""
    var password_ = ""
    var confirmPassword_ = ""
    var email_ = ""
    var username_ = ""
    var profPic_: UIImage
    
    @IBAction func goToLoginButton(sender: AnyObject) {
        self.performSegueWithIdentifier("goBackToLogin", sender: self)
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
            profPic_ = profPicImageView.image!
            
            let user = PFUser(className: "_User")
            user.password = password_
            user.email = email_
            user.username = username_
            user["profPic"] = profPic_
            user["Name"] = name_
            
        self.performSegueWithIdentifier("createAccountToFeed", sender: self)
        
        }
        
    }
    
    
    func displayAlert(title: String, displayError: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: {
            action in self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
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
        profPicImageView.image = image // puts in image
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
