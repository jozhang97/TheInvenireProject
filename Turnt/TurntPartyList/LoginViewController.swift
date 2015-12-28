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
    var activateLabel = false


    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "titlepageBackground1")!)
        loginButton.layer.backgroundColor  = UIColor.orangeColor().CGColor
        loginButton.layer.cornerRadius = 10
        super.viewDidLoad()
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        loginButton.center = self.view.center
//        loginButton.delegate = self
//        self.view.addSubview(loginButton)
//        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
//        // Do any additional setup after loading the view, typically from a nib.
        if activateLabel == true {
            updateCreationLabel()
        }
    }
    
    
    @IBOutlet weak var successfulCreationLabel: UILabel!
    
    func updateCreationLabel() {
        self.successfulCreationLabel.alpha = 1.0
        self.successfulCreationLabel.text = "Account Made!"
        self.successfulCreationLabel.textColor = UIColor.greenColor()
        // Fade out to set the text
        UIView.animateWithDuration(3.0, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.successfulCreationLabel.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                self.successfulCreationLabel.text = " "
        })
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
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 10, options: [], animations: {
            self.loginButton.bounds = CGRect(x: bounds.origin.x - 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            self.loginButton.enabled = true
            PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
                (success, loginError) in
                
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
