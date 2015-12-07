//
//  LoginViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/13/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginButton = FBSDKLoginButton()
//        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
//        loginButton.center = self.view.center
//        loginButton.delegate = self
//        self.view.addSubview(loginButton)
//        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
//        // Do any additional setup after loading the view, typically from a nib.
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
