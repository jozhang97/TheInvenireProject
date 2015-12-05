//
//  LoginViewController.swift
//  TurntPartyList
//
//  Created by Shaili Patel on 11/13/15.
//  Copyright © 2015 Shaili Patel. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: ViewController, FBSDKLoginButtonDelegate {
    

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginButtonView: UIButton!
    @IBOutlet weak var loginWithFB: UIButton!
    @IBOutlet weak var createAccount: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            print("not logged in")
        } else {
            print("logged in")
        }
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error == nil) {
            print("Login complete")
            self.performSegueWithIdentifier("showFB", sender: self)
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("user logged out")
    }
    
    
    func displayAlert(title: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    let displayError = ""
    // all we need to log in on parse

    @IBAction func LoginButton(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
            (success, loginError) in
            
            if loginError == nil {
                self.performSegueWithIdentifier("toMainVC", sender: self)
            } else {
                self.displayAlert("Wrong username or password")
                print("Error")
                
            }
        }
    }
    
    @IBAction func createAccountButton(sender: AnyObject) {
    self.performSegueWithIdentifier("toCreateAccount", sender: self)
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
