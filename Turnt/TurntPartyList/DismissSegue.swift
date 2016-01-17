//
//  DismissSegue.swift
//  Invenire
//
//  Created by Virindh Borra on 1/15/16.
//  Copyright © 2016 Jeffrey Zhang. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {

    //Dismiss the source view controller, endpoint wherever you feel like ¯\_(ツ)_/¯
    override func perform()
    {
        self.sourceViewController.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
