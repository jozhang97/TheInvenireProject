//
//  changeProfileVC.swift
//  Invenire
//
//  Created by Abhi on 12/5/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class changeProfileVC: UIViewController {
    
    @IBAction func changePassword(sender: AnyObject) {
        let currentEmail = PFUser.currentUser()!["email"] as! String
        PFUser.requestPasswordResetForEmailInBackground(currentEmail)
        PFUser.logOut()
        if (PFUser.currentUser() == nil) {
            //go back to rootviewController which is the login screen
            self.performSegueWithIdentifier("toLogin", sender: nil)
        }
    }
            
    @IBOutlet weak var newEmail: UITextField!
    
    @IBAction func submitButton(sender: AnyObject) {
        if let currentUser = PFUser.currentUser(){
            currentUser["email"] = newEmail.text
            currentUser.saveInBackground()
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
