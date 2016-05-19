//
//  SignUpViewController.swift
//  A1
//
//  Created by Ricky on 2016/4/7.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: LoadingViewController {

    @IBOutlet weak var usernameTextview: UITextField!
    @IBOutlet weak var passwordTextview: UITextField!
    @IBOutlet weak var comfirmPassTextview: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signUpTapped(sender: AnyObject) {
        let userName = usernameTextview.text;
        let userPassword = passwordTextview.text;
        let userRepeatPassword = comfirmPassTextview.text;
        
        // Show progress spinner
        
        startActivityIndicator()
        
        // Check for empty fields
        if(userName!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty)
        {
            
            // Display alert message
            
            displayAlertMessage("All fields are required");
            
            return;
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword)
        {
            // Display an alert message
            displayAlertMessage("Passwords do not match");
            return;
            
        }
        
        auth(userName!, pw: userPassword!)
        
        
        // Store data
      

        
    }
    
    func displayAlertMessage(userMessage:String)
    {
        stopActivityIndicator()
        
        let alertCtl = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let successAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil);
        
        alertCtl.addAction(successAction);
        
        self.presentViewController(alertCtl, animated:true, completion: nil);
        
    }
    
    func auth(name: String, pw: String) {
        FIREBASE_REF.createUser(name, password: pw, withValueCompletionBlock: {(error, authData) -> Void in
            if error != nil {
                print("Create fail")
                self.stopActivityIndicator()
                self.displayAlertMessage("Create Account failed")
                // Something went wrong. :(
            } else {
                // Account created
                FIREBASE_REF.authUser(name, password: pw, withCompletionBlock: { (error, authData) in
                    if error != nil {
                        self.stopActivityIndicator()
                        self.displayAlertMessage("Create Account failed")
                        // Login failed
                    } else {
                        
                        //let dname = authData.providerData["displayName"] as! String
                        let newUser = [
                            "provider": authData.provider,
                            "displayName": name
                        ]
                        // Create a child path with a key set to the uid underneath the "users" node
                        // This creates a URL path like the following:
                        
                        FIREBASE_REF.childByAppendingPath("users")
                            .childByAppendingPath(authData.uid).setValue(newUser)
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                        print("User: \(authData.uid) is created");
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
        })
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
