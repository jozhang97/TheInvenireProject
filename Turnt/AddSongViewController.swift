//
//  makePartyViewController.swift
//  TurntPartyList
//
//  Created by Jeffrey Zhang on 11/14/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit

class AddSongViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var songName: UITextField!
    @IBOutlet weak var artistName: UITextField!
    @IBOutlet weak var albumName: UITextField!
    
    
    @IBAction func submit(sender: AnyObject) {
        var displayError = ""
        if songName.text == ""{
            displayError = "Please enter a song name"
        }
        else if artistName.text == ""
        {
            displayError = "Please enter an artist"
        }

        if displayError !=  ""
        {
            displayAlert("Incomplete form", displayError: displayError)
        }
        else
        {
            let Test = PFObject(className: "Songs")
            Test["Song"] = songName.text!
            Test["Artist"] = artistName.text!
            Test["Album"] = albumName.text!
            Test["likes"] = 0
//            let geo = PFGeoPoint()
//            Test["location"] = PFGeoPoint.geoPointForCurrentLocationInBackground(<#T##resultBlock: PFGeoPointResultBlock?##PFGeoPointResultBlock?##(PFGeoPoint?, NSError?) -> Void#>)
            Test.saveInBackgroundWithBlock { (succeeded, signupError) -> Void in
                if signupError == nil{
                    self.performSegueWithIdentifier("submitParty", sender: nil)
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
        
        self.presentViewController(alert, animated: true, completion: nil)
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
