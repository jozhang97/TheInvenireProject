//
//  SignUpViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/14/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var email: UITextField!

    func displayAlert(title: String, displayError: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        //ERROR HERE, HANDLER = NIL SINCE NOTHING HAPPENS
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func continueSignup(sender: AnyObject) {
        var displayError = ""
        if username.text == ""{
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
        else if email.text == ""
        {
            displayError = "Please enter a email"
        }
        else if name.text == ""
        {
            displayError = "Please enter a name"
        }
        
        if displayError != ""
        {
            displayAlert("Incomplete form", displayError: displayError)
        }
        else
        {
            self.performSegueWithIdentifier("toAddUserInfo", sender: self)
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toAddUserInfo"
        {
            let addUserInfoVC = segue.destinationViewController as! AddUserInfoViewController
            addUserInfoVC.username = username.text!
            addUserInfoVC.password = password.text!
            addUserInfoVC.name = name.text!
            addUserInfoVC.confirmPassword = confirmPassword.text!
            addUserInfoVC.email = email.text!
            
        }
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
