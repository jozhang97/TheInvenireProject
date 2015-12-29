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


class LoginViewController: ViewController {
//FBSDKLoginButtonDelegate
    
    // start of FB Stuff

//    override func viewDidAppear(animated: Bool) {
//        if (FBSDKAccessToken.currentAccessToken() == nil) {
//            print("not logged in")
//        } else {
//            print("logged in")
//            self.performSegueWithIdentifier("toFB", sender: self)
//        }
//    }
    
//    //MARK: Facebook Login
//    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
//        if (error == nil) {
//            print("Login complete")
//        } else {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func putDataInDB() {
//        let user = PFUser.currentUser()
//        user!["Name"] = FBSDKProfile.currentProfile().name
//        user!.username = ""
//        user!.password = ""
//        user!.email = ""
//        user!["confirmPassword"] = ""
//        user!.saveInBackground()
//    }
//    
//    
//    
//    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
//        print("user logged out")
//    }
//
//    @IBAction func facebookLogin(sender: AnyObject) {
//        
//    }
    
    // End Facebook stuff
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var bufferView: UIActivityIndicatorView!


    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        loginButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        loginButton.layer.cornerRadius = 10
        super.viewDidLoad()
        //Do any additional setup after loading the view, typically from a nib.
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
        let bounds = self.loginButton.bounds
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            view.insertSubview(bufferView, aboveSubview: view)
        } 
        else {
            self.view.backgroundColor = UIColor.blackColor()
        }
        bufferView.startAnimating()
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            self.loginButton.enabled = true
            PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
                (success, loginError) in
                self.bufferView.stopAnimating()
                if loginError == nil {
                    self.performSegueWithIdentifier("toMainVC", sender: self)
                } else {
                    self.displayAlert("Wrong username or password")
                    print("Error")
                    
                }
            }
            }, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
