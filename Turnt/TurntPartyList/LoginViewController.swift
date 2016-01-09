//
//  LoginViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/13/15.
//  Copyright © 2015 Jeffrey Zhang, Abhishek Mangla. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import QuartzCore


class LoginViewController: ViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bufferView: UIActivityIndicatorView!

    
    //locks VC in portrait orientation
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
    //end of locking vc to portrait code
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        loginButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        loginButton.layer.cornerRadius = 10
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.username.delegate = self
        self.password.delegate = self
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func displayAlert(title: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    let displayError = ""
    // all we need to log in on parse
    
    @IBAction func Login(sender: AnyObject) {
        bufferView.startAnimating()
        
        let bounds = self.loginButton.bounds
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        //always fill the view
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
        view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        view.insertSubview(bufferView, aboveSubview: view)
        
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            self.loginButton.enabled = true}, completion: nil)
            
        PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
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
