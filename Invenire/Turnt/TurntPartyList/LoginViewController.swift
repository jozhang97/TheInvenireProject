//
//  LoginViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/13/15.
//  Copyright © 2015 Jeffrey Zhang, Abhishek Mangla. All rights reserved.
//

import UIKit
import QuartzCore

class LoginViewController: ViewController, UITextFieldDelegate {
    
    let bufferView = UIActivityIndicatorView (frame: CGRectMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2, 20, 20))
    let username = UITextField (frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2, UIScreen.mainScreen().bounds.width - 40, 20))
    let usernameLine = UIButton(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2 + 22, UIScreen.mainScreen().bounds.width - 40, 1))
    let password = UITextField (frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2 + 40, UIScreen.mainScreen().bounds.width - 40, 20))
    let passwordLine = UIButton(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2 + 62, UIScreen.mainScreen().bounds.width - 40, 1))
    let loginButton = UIButton(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height/2 + 80, UIScreen.mainScreen().bounds.width - 40, 30))
    let titleName = UILabel(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height*1/4, UIScreen.mainScreen().bounds.width - 20, 50))
    let accountMake = UILabel(frame: CGRectMake(10, UIScreen.mainScreen().bounds.height*3/4, UIScreen.mainScreen().bounds.width - 20, 15))
    let createAccountButton = UIButton(frame: CGRectMake(20, UIScreen.mainScreen().bounds.height*3/4 + 20, UIScreen.mainScreen().bounds.width - 40, 30))
    
    let displayError = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitle()
        setupUsername()
        setupPassword()
        setupLoginButton()
        setupNewUser()
        setupBufferView()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        username.delegate = self
        password.delegate = self
    }
    
    func setupBufferView() {
        bufferView.color = UIColor.redColor()
    }
    
    func setupUsername() {
        username.backgroundColor = UIColor.clearColor()
        username.attributedPlaceholder = NSAttributedString(string:"USERNAME",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        usernameLine.layer.borderWidth = 1
        usernameLine.layer.borderColor = UIColor.whiteColor().CGColor
        username.textColor = UIColor.whiteColor()
        view.addSubview(username)
        view.addSubview(usernameLine)
    }
    
    func setupPassword() {
        password.backgroundColor = UIColor.clearColor()
        password.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        password.textColor = UIColor.whiteColor()
        password.secureTextEntry = true
        passwordLine.layer.borderWidth = 1
        passwordLine.layer.borderColor = UIColor.whiteColor().CGColor
        
        view.addSubview(password)
        view.addSubview(passwordLine)
    }
    
    func setupTitle() {
        titleName.text = "INVENIRE"
        titleName.font = UIFont(name: "Futura", size: 60)
        titleName.textColor = UIColor.whiteColor()
        titleName.textAlignment = .Center
        
        view.addSubview(titleName)
    }
    
    func setupLoginButton() {
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.setTitle("LOG IN", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.borderWidth = 1
        loginButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(loginButton)
    }
    
    func setupNewUser() {
        accountMake.text = "DON'T HAVE AN ACCOUNT?"
        accountMake.textAlignment = .Center
        accountMake.textColor = UIColor.whiteColor()
        accountMake.font = UIFont(name: "Futura", size: 15)
        createAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createAccountButton.setTitle("SIGN UP", forState: .Normal)
        createAccountButton.backgroundColor = UIColor.clearColor()
        createAccountButton.layer.borderColor = UIColor.whiteColor().CGColor
        createAccountButton.layer.borderWidth = 1
        createAccountButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        view.addSubview(accountMake)
        view.addSubview(createAccountButton)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.placeholder = nil
        textField.autocapitalizationType = .None
        textField.autocorrectionType = .No
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == username {
            textField.attributedPlaceholder = NSAttributedString(string:"USERNAME",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
        else if textField == password {
            textField.attributedPlaceholder = NSAttributedString(string:"PASSWORD",
                attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        }
    }
    
    func displayAlert(title: String) {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func pressed(sender: UIButton!) {
        if sender == loginButton {
            bufferView.startAnimating()
            
            let bounds = loginButton.bounds
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            //always fill the view
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            view.insertSubview(bufferView, aboveSubview: view)
            
            UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
                self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
                self.loginButton.enabled = true}, completion: nil)
            
            PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
                (success, loginError) in
                self.bufferView.stopAnimating()
                if loginError == nil {
                    self.performSegueWithIdentifier("toMainVC", sender: self)
                } else {
                    self.displayAlert("Wrong username or password")
                    blurEffectView.removeFromSuperview()
                }
            }
        }
        else if sender == createAccountButton {
            performSegueWithIdentifier("toSignUp", sender: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("toMainVC", sender: self)
        }
    }

}
