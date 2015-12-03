//
//  AddUserInfoViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/14/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class AddUserInfoViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var chooseProfPicButton: UIButton!
    @IBOutlet weak var profPicImageView: UIImageView!
    
    var username = ""
    var name = ""
    var password = ""
    var confirmPassword = ""
    var email = ""
    var gender = "male"
    var birthday = ""
    
    
    @IBAction func chooseProfilePicture(sender: AnyObject) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        self.presentViewController(image, animated: true, completion: nil)
    }
        
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        profPicImageView.image = image // puts in image

    }
    
    @IBAction func signupUser(sender: AnyObject) {
        var displayError = ""
        
        if birthdayTextField.text == "" {
            displayError = "please enter a birthday"
        }
        if profPicImageView.image == nil
        {
            displayError = "please upload a pictue"
        }
        if displayError != "" {
            displayAlert("Missing Info", displayError: displayError)
        } else
        {
            // to send data to parse, just need to define a PFUser and set stuff equal
            let user = PFUser()
            user.username = username
            user.password = password
            user.email = email
            user["name"] = name // since not part of initial parse table
            user["gender"] = gender
            user["birthday"] = birthdayTextField.text
            let profPicFile = PFFile(name: "profilePicture.png", data: UIImageJPEGRepresentation(profPicImageView.image!, 0.5)!)
            user["cal1card"] = profPicFile
            
//            self.performSegueWithIdentifier("toMainVCFromSignUp", sender: nil) // should be in loop under the line this but then need to press sign up 2x, not sure why
        
            user.signUpInBackgroundWithBlock { (succeeded, signupError) -> Void in
                if signupError == nil{
                    self.performSegueWithIdentifier("toMainVCFromSignUp", sender: nil)
                } else {
                    if let error = signupError!.userInfo["error"] as? NSString {
                        displayError = error as String
                    } else {
                        displayError = "Please try again later"
                    }
                    self.displayAlert("Could not sign up", displayError: displayError)
                
                }
        
            }
        }
    }
    
    func displayAlert(title: String, displayError: String)
    {
        let alert = UIAlertController(title: title, message: displayError, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Default, handler: nil))
        //ERROR HERE, HANDLER = NIL SINCE NOTHING HAPPENS
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldDidChange(textField: UITextField) //something wrong with this
    {
        if birthdayTextField.text!.characters.count == 2
        {
            birthdayTextField.text = birthdayTextField.text! + "/"
        }
        if birthdayTextField.text!.characters.count == 5
        {
            birthdayTextField.text = birthdayTextField.text! + "/"
        }
    }
    
    @IBAction func maleButtonPressed(sender: AnyObject) {
        gender = "male"
        maleButton.highlighted = false
        femaleButton.highlighted = true
    }

    @IBAction func femaleButtonPressed(sender: AnyObject) {
        gender = "female"
        maleButton.highlighted = true
        femaleButton.highlighted = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        femaleButton.highlighted = true
        birthdayTextField.keyboardType = UIKeyboardType.PhonePad // change to numbers only
        birthdayTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged) // calls or targets action when edited
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
