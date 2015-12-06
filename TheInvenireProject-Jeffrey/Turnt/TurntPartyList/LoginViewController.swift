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
    @IBOutlet weak var login: UIButton!
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
        
        /* The code below checks if the current user is nil. If it isn't that means a user is logged in on the app, and it takes the user to the main view controller */
        
        /* MAKE SURE TO INSERT THE ID OF THE SEGUE THAT YOU WANT TO OCCUR IF THE USER IS ALREADY LOGGED IN (A SEGUE FROM THIS VIEW CONTROLLER TO YOUR MAIN VIEW CONTROLLER ONCE THE USER IS LOGGED IN) */
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("toMainVC", sender: self)
        }
    }
    
    func putDataInDB() {
        
        // Gets the current user
        var user =  PFUser.currentUser()!
        
        // Make a request to get all the fields of the user that you want to put into your DB.
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                //If an error occurs, print the error
                print("Error: \(error)")
                
            } else {
                
                //If all goes well, set all the fields of the user object
                if let userName : NSString = result.valueForKey("name") as? NSString {
                    user["username"] = userName
                } else {print("No username fetched")}
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    user["email"] = userEmail
                } else  {print("No email address fetched")}
                
                //Save the user's info into your DB
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success == false{
                        print("Error")
                    } else {
                        print("User Information has been saved.")
                    }
                })
                
            }
        })
        
        //Make a request to get the user's profile picture from Facebook
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                if let profilePicURL : String  = (result.valueForKey("data")!).valueForKey("url") as? String {
                    
                    let url = NSURL(string: profilePicURL)
                    let urlRequest = NSURLRequest(URL: url!)
                    NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        (response, data, error) in
                        
                        
                        // Construct a UIImage out of the imagedata received from the request
                        let image = UIImage(data: data!)
                        
                        
                        // Construct a PFFile to store in your Parse DB out of the UIImage
                        let imageFile = PFFile(name: "profpic.png", data: UIImagePNGRepresentation(image!)!)
                        
                        // If images are too big, you can compress them using a UIIMageJPEGRepresentation before storing them in Parse. Parse only allows PFFiles up to 10 mb. If you wanted to do this, your code would look like this instead:
                        // let imageFile = PFFile(name: "profpic.png", data: UIImageJPEGRepresentation(image, 0.5))
                        
                        //Set the user object's profilePicture field
                        user["profPic"] = imageFile
                        
                        
                        //Save the updated user object
                        user.saveInBackgroundWithBlock({ (success, error) -> Void in
                            if success == false{
                                print("Image save unsuccessful")
                            } else {
                                print("Your profile picture was saved successfully")
                            }
                        })
                    })
                    
                    
                    /* ONCE THE USER IS SIGNED UP, YOU WANT TO TAKE THEM TO A VIEW CONTROLLER. PUT THE ID OF THAT SEGUE BELOW AND UNCOMMENT THE LINE */
                    
                    // self.performSegueWithIdentifier("", sender: self)
                    
                } else {
                    
                    print("Error") }
                
            } else {
                
                print("\(error)")
                
            }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error == nil) {
            print("Login complete")
            
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
    
    
    @IBAction func loginButton(sender: AnyObject) {
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
