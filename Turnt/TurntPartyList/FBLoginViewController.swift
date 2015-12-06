//
//  FBLoginViewController.swift
//  Invenire
//
//  Created by Shaili Patel on 12/3/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FBLoginViewController: UIViewController, UIImagePickerControllerDelegate {
    

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var `continue`: UIButton!
 
    @IBOutlet weak var uploadPic: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Hello " + FBSDKProfile.currentProfile().name + "!"
        print("Hello " + FBSDKProfile.currentProfile().name + "!")
        let _user = PFUser(className: "_User")

        _user.email = ""
        _user.username = FBSDKProfile.currentProfile().name
        _user.password = ""
        _user["confirmPassword"] = ""
        _user["profPic"] = profilePic.image
    }
    

  
    @IBAction func continueButton(sender: AnyObject) {
    self.performSegueWithIdentifier("FBContinueOn", sender: self)
    }
    
    
    @IBAction func uploadPicButton(sender: AnyObject) {
        let image = UIImagePickerController()
        //image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    

func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
    self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
   profilePic.image = image // puts in image
    
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
