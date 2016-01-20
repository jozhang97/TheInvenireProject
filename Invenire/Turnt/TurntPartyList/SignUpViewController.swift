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

class SignUpViewController: ViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate{
    
    let profPic = UIImageView()
    let submitButton = UIButton()
    let scrollView = UIScrollView()
    let titleLabel = UILabel()
    let loginButton = UIButton()
    let accountMake = UILabel()
    let enterPicButton = UIButton()
    
    let bufferView = UIActivityIndicatorView (frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2, 20, 20))
    let nameF = UITextField (frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*3/10, UIScreen.mainScreen().bounds.width*3/5, 20))
    let usernameF = UITextField (frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*4/10, UIScreen.mainScreen().bounds.width*3/5, 20))
    let passwordF = UITextField (frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*5/10, UIScreen.mainScreen().bounds.width*3/5, 20))
    let confirmF = UITextField (frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*6/10, UIScreen.mainScreen().bounds.width*3/5, 20))
    let emailF = UITextField (frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*7/10, UIScreen.mainScreen().bounds.width*3/5, 20))
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailF || textField == confirmF {
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
    
    func createAccount() {
        let username = usernameF.text
        let password = passwordF.text
        let email = emailF.text
        let finalEmail = email!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let name = nameF.text
        let confirmPassword = confirmF.text
        
        
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
            // Run a spinner to show a task in progress
            bufferView.startAnimating()
            
            let newUser = PFUser()
            
            newUser.username = username
            newUser.password = password
            newUser.email = finalEmail
            newUser["Name"] = name
            newUser["confirmPassword"] = confirmPassword
            
            if profPic.image == nil {
                let profPicFile = PFFile(name: name! + "_picture", data: UIImageJPEGRepresentation(UIImage(named: "genericProfilePic.png")!, 0.5)!)
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
                    /*
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Home") 
                        self.presentViewController(viewController, animated: true, completion: nil)
                    })
                    */
                }
                PFUser.logOut()
                self.performSegueWithIdentifier("toLogin", sender: self)
            })
        }
    }
    
    func chooseImage(sender: AnyObject) {
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
    
    func setupTitle() {
        titleLabel.text = "CREATE AN ACCOUNT"
        titleLabel.frame = CGRectMake(40, 20, UIScreen.mainScreen().bounds.width - 80, 40)
        titleLabel.font = UIFont(name: "Futura", size: 25)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(titleLabel)
    }
    
    func setupProfilePic() {
        
        profPic.backgroundColor = UIColor.clearColor()
        profPic.layer.cornerRadius = profPic.frame.size.width / 2;
        profPic.clipsToBounds = true
        profPic.layer.borderColor = UIColor.blackColor().CGColor
        profPic.layer.borderWidth = 3;
        profPic.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 55, UIScreen.mainScreen().bounds.height/10, 110, 110)
        
        view.addSubview(profPic)
        
        enterPicButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        enterPicButton.setTitle("CLICK TO BROWSE", forState: .Normal)
        enterPicButton.titleLabel?.font = UIFont(name: "Futura", size: 20)
        enterPicButton.titleLabel?.adjustsFontSizeToFitWidth = true
        enterPicButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width/2 - 58, UIScreen.mainScreen().bounds.height/10, 120, 120)
        enterPicButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(enterPicButton)
    }
    
    func setupTextFields() {
        
        
        let nameLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*3/10 + 22, UIScreen.mainScreen().bounds.width*3/5, 1))
        
        nameF.backgroundColor = UIColor.clearColor()
        nameF.attributedPlaceholder = NSAttributedString(string:"NAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        nameLine.layer.borderWidth = 1
        nameLine.layer.borderColor = UIColor.whiteColor().CGColor
        nameF.textColor = UIColor.whiteColor()
        view.addSubview(nameF)
        view.addSubview(nameLine)
        
        
        let usernameLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*4/10 + 22, UIScreen.mainScreen().bounds.width*3/5, 1))
        
        usernameF.backgroundColor = UIColor.clearColor()
        usernameF.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameLine.layer.borderWidth = 1
        usernameLine.layer.borderColor = UIColor.whiteColor().CGColor
        usernameF.textColor = UIColor.whiteColor()
        view.addSubview(usernameF)
        view.addSubview(usernameLine)
    
        
        let passwordLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*5/10 + 22, UIScreen.mainScreen().bounds.width*3/5, 1))
        
        passwordF.backgroundColor = UIColor.clearColor()
        passwordF.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordLine.layer.borderWidth = 1
        passwordLine.layer.borderColor = UIColor.whiteColor().CGColor
        passwordF.textColor = UIColor.whiteColor()
        passwordF.secureTextEntry = true
        view.addSubview(passwordF)
        view.addSubview(passwordLine)
        
        
        let confirmLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*6/10 + 22, UIScreen.mainScreen().bounds.width*3/5, 1))
        
        confirmF.backgroundColor = UIColor.clearColor()
        confirmF.attributedPlaceholder = NSAttributedString(string:"CONFIRM PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        confirmLine.layer.borderWidth = 1
        confirmLine.layer.borderColor = UIColor.whiteColor().CGColor
        confirmF.textColor = UIColor.whiteColor()
        confirmF.secureTextEntry = true
        view.addSubview(confirmF)
        view.addSubview(confirmLine)
        
        
        let emailLine = UILabel(frame: CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*7/10 + 22, UIScreen.mainScreen().bounds.width*3/5, 1))
        
        emailF.backgroundColor = UIColor.clearColor()
        emailF.attributedPlaceholder = NSAttributedString(string:"EMAIL",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailLine.layer.borderWidth = 1
        emailLine.layer.borderColor = UIColor.whiteColor().CGColor
        emailF.textColor = UIColor.whiteColor()
        view.addSubview(emailF)
        view.addSubview(emailLine)
        
        nameF.delegate = self
        usernameF.delegate = self
        passwordF.delegate = self
        confirmF.delegate = self
        emailF.delegate = self
    }
    
    func setupButtons() {
        submitButton.backgroundColor = UIColor.clearColor()
        submitButton.setTitle("SUBMIT", forState: .Normal)
        submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        submitButton.layer.borderColor = UIColor.whiteColor().CGColor
        submitButton.layer.borderWidth = 1
        submitButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        submitButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*8/10, UIScreen.mainScreen().bounds.width*3/5, 25)
        view.addSubview(submitButton)
    
        accountMake.text = "ALREADY HAVE AN ACCOUNT?"
        accountMake.textAlignment = .Center
        accountMake.textColor = UIColor.whiteColor()
        accountMake.font = UIFont(name: "Futura", size: 15)
        accountMake.adjustsFontSizeToFitWidth = true
        accountMake.frame = CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*8.5/10, UIScreen.mainScreen().bounds.width*3/5, 25)
        
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.setTitle("LOG IN", forState: .Normal)
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 1
        loginButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        loginButton.frame = CGRectMake(UIScreen.mainScreen().bounds.width/5, UIScreen.mainScreen().bounds.height*9/10, UIScreen.mainScreen().bounds.width*3/5, 25)
        
        view.addSubview(accountMake)
        view.addSubview(loginButton)
    }
    
    func pressed(sender: UIButton!) {
        if sender == submitButton {
            createAccount()
        }
        else if sender == loginButton {
            performSegueWithIdentifier("toLogin", sender: self)
        }
        else if sender == enterPicButton {
            chooseImage(self)
        }
    }
    
    func setupBufferView() {
        bufferView.color = UIColor.redColor()
        view.addSubview(bufferView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupProfilePic()
        setupTextFields()
        setupButtons()
        setupBufferView()
        
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