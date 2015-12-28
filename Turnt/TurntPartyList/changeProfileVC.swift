//
//  changeProfileVC.swift
//  Invenire
//
//  Created by Abhi on 12/5/15.
//  Copyright © 2015 Abhishek Mangla. All rights reserved.
//

import UIKit

class changeProfileVC: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBAction func updatePicture(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func confirmPic(sender: AnyObject) {
        let profPicFile = PFFile(name: "newpicture", data: UIImageJPEGRepresentation(profilePicImageView.image!, 0.5)!)
        PFUser.currentUser()!["profPic"] = profPicFile
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        profilePicImageView.image = image // puts in image
        
    }
    
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "cityBackground")!)
        
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
