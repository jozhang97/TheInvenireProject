//
//  FBLoginViewController.swift
//  Invenire
//
//  Created by Shaili Patel on 12/3/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class FBLoginViewController: UIViewController {
    

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var `continue`: UIButton!


    override func viewDidLoad() {
        name.text = "Hello " + FBSDKProfile.currentProfile().name + "!"
        print("Hello " + FBSDKProfile.currentProfile().name + "!")
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                println("\(result)")
            } else {
                println("\(error)")
            }
        })
        let _user = PFUser()
        _user.Name = name.text!
        _user.profilePic = 
        
        // Do any additional setup after loading the view.
    }

    @IBAction func continueButton(sender: AnyObject) {
    self.performSegueWithIdentifier("FBContinueOn", sender: self)
    
    }
        
        // Do any additional setup after loading the view.
    
    
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
