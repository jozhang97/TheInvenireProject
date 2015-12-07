//
//  FBLoginViewController.swift
//  Invenire
//
//  Created by Apple on 12/6/15.
//  Copyright © 2015 Jeffrey Zhang. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FBLoginViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profPic: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = "Hello" + FBSDKProfile.currentProfile().name + "!"
        print ("Hello" + FBSDKProfile.currentProfile().name + "!")
        // Do any additional setup after loading the view.
    }

    
    @IBAction func chooseImage(sender: AnyObject) {
        let image = UIImagePickerController()
        
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) { // different ? !
        
        self.dismissViewControllerAnimated(true, completion: nil) // controller goes away
        
        profPic.image = image // puts in image
        
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
