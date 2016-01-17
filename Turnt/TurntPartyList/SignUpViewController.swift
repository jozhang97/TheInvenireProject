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
import QuartzCore

class SignUpViewController: ViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate{
    
    var submitButton = UIButton ()
    var emailField = UITextField ()
    var confirmPasswordField = UITextField()
    var passwordField = UITextField()
    var usernameField = UITextField()
    var nameField = UITextField()
    
    let login = UILabel(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height*3/4, UIScreen.mainScreen().bounds.width - 20, 15))
    let loginButton = UIButton(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height*3/4 + 20, UIScreen.mainScreen().bounds.width - 40, 30))
    
    let bufferView = UIActivityIndicatorView (frame: CGRectMake(UIScreen.mainScreen().bounds.width/2-10, UIScreen.mainScreen().bounds.height/2-10, 20, 20))
    
    let titleLabel = UILabel()
    let titleLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/4 - 10, UIScreen.mainScreen().bounds.height/10, UIScreen.mainScreen().bounds.width/2 + 20, 1))
    
    let profPic = UIImageView()
    let choosePictureButton = UIButton()
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    
    func containDB(test: String, classer: String, column: String) -> Bool {
        var num = 0
        let query = PFQuery(className: classer)
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        profPic.image = image // puts in image
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeTitle()
        makePicture()
        setupTextFields()
        setupTextFieldLines()
        setupSubmitButton()
        setupLoginButton()
        setupBufferView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func setupTextFields() {
        nameField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        emailField.delegate = self
        
        nameField.backgroundColor = UIColor.clearColor()
        nameField.attributedPlaceholder = NSAttributedString(string:"NAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        nameField.frame = CGRectMake(20, UIScreen.mainScreen().bounds.height*3/10 ,UIScreen.mainScreen().bounds.width - 40, 20)
        
        usernameField.backgroundColor = UIColor.clearColor()
        usernameField.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameField.frame = CGRectMake(20, UIScreen.mainScreen().bounds.height*4/10,UIScreen.mainScreen().bounds.width - 40, 20)
        
        passwordField.backgroundColor = UIColor.clearColor()
        passwordField.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordField.frame = CGRectMake(20, UIScreen.mainScreen().bounds.height*5/10 ,UIScreen.mainScreen().bounds.width - 40, 20)
        
        confirmPasswordField.backgroundColor = UIColor.clearColor()
        confirmPasswordField.attributedPlaceholder = NSAttributedString(string:"CONFIRM PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        confirmPasswordField.frame = CGRectMake(20, UIScreen.mainScreen().bounds.height*6/10 ,UIScreen.mainScreen().bounds.width - 40, 20)
        
        emailField.backgroundColor = UIColor.clearColor()
        emailField.attributedPlaceholder = NSAttributedString(string:"EMAIL",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailField.frame = CGRectMake(20, UIScreen.mainScreen().bounds.height*7/10,UIScreen.mainScreen().bounds.width - 40, 20)
        
        view.addSubview(nameField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(emailField)
    }
    
    func setupTextFieldLines() {
        let nameLine = UILabel(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2 - 78, UIScreen.mainScreen().bounds.width - 40, 1))
        nameLine.layer.borderWidth = 1
        nameLine.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(nameLine)
    }
    
    func setupSubmitButton() {
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.setTitle("SUBMIT", forState: .Normal)
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitButton.layer.borderWidth = 2
        submitButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(submitButton)
    }
    
    func setupLoginButton() {
        login.text = "ALREADY HAVE AN ACCOUNT?"
        login.textAlignment = .Center
        login.textColor = UIColor.whiteColor()
        login.font = UIFont(name: "Futura", size: 15)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.setTitle("LOG IN", forState: .Normal)
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 2
        loginButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(login)
        view.addSubview(loginButton)
    }
    
    func setupBufferView() {
        bufferView.color = UIColor.redColor()
    }
    
    func makePicture() {
        profPic.image = UIImage(named: "profileIcon2")
        profPic.layer.cornerRadius = profPic.frame.size.width / 2;
        profPic.clipsToBounds = true
        profPic.contentMode = .ScaleAspectFill
        profPic.layer.borderWidth = 2
        profPic.layer.borderColor = UIColor.whiteColor().CGColor
        profPic.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2-50, UIScreen.mainScreen().bounds.height/10 + 20, 100, 100)
        view.addSubview(profPic)
        
        
        choosePictureButton.backgroundColor = UIColor.clearColor()
        choosePictureButton.setTitle("CHOOSE PROFILE PIC", forState: .Normal)
        choosePictureButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        choosePictureButton.layer.borderColor = UIColor.whiteColor().CGColor
        choosePictureButton.layer.borderWidth = 1
        choosePictureButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        choosePictureButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - UIScreen.mainScreen().bounds.width/4, UIScreen.mainScreen().bounds.height/10+130, UIScreen.mainScreen().bounds.width/2, 25)
        
        view.addSubview(choosePictureButton)
    }
    
    func makeTitle() {
        titleLabel.text = "CREATE AN ACCOUNT"
        titleLabel.font = UIFont(name: "Futura", size: 20)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.frame = CGRectMake(10, UIScreen.mainScreen().bounds.height/10-22, UIScreen.mainScreen().bounds.width - 20, 20)
        
        titleLine.layer.borderWidth = 1
        titleLine.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(titleLabel)
        view.addSubview(titleLine)
    }
    
    func pressed(sender: UIButton!) {
        if sender == choosePictureButton {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            image.allowsEditing = false
            self.presentViewController(image, animated: true, completion: nil)
        }
        else if sender == loginButton {
            performSegueWithIdentifier("toLogin", sender: self)
        }
        else if sender == submitButton {
            let username = self.usernameField.text
            let password = self.passwordField.text
            let email = self.emailField.text
            let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let name = self.nameField.text
            let confirmPassword = self.confirmPasswordField.text
            
            
            // Validate the text fields
            if username!.characters.count < 5 {
                let alert = UIAlertView(title: "Invalid", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            } else if password!.characters.count < 8 {
                let alert = UIAlertView(title: "Invalid", message: "Password must be greater than 8 characters", delegate: self, cancelButtonTitle: "OK")
                alert.show()
                
            } else if email!.characters.count < 8 || email!.containsString("@") == false {
                let alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else if confirmPassword != password {
                let alert = UIAlertView(title: "Invalid", message: "Passwords do not match!", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            else {
                bufferView.startAnimating()
                
                let newUser = PFUser()
                
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
                    self.bufferView.stopAnimating()
                    if ((error) != nil) {
                        let alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        
                    } else {
                        let alert = UIAlertView(title: "Success", message: "Signed Up", delegate: self, cancelButtonTitle: "OK")
                        alert.show()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home")
                            self.presentViewController(viewController, animated: true, completion: nil)
                        })
                    }
                })
            }
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}