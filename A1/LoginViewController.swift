//
//  LoginViewController.swift
//  A1
//
//  Created by Ricky on 2016/4/7.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit

class LoginViewController: LoadingViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide login and logout buttons
        hideButtons()
        
        // Check if user is logged in
            // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        let userName = usernameTextfield.text;
        let userPassword = passwordTextfield.text;
        
        // Show progress spinner
        
        startActivityIndicator()
        
        // Check for empty fields
        if(userName!.isEmpty || userPassword!.isEmpty)
        {
            
            // Display alert message
            
            displayAlertMessage("All fields are required");
            
            return;
        }
        
        self.auth(userName!, pw: userPassword!)

    
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
                logedIn(false)
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
        
    }

    func logedIn(flag: Bool) {
        if flag {
            print("Hide login")
        } else {
            print("Hide Logout")
        }
        loginButton.hidden = flag
        logoutButton.hidden = !flag
    }
    
    func hideButtons() {
        loginButton.hidden = true
        logoutButton.hidden = true
    }
    
    override func startActivityIndicator() {
        super.startActivityIndicator()
        usernameTextfield.enabled = false
        passwordTextfield.enabled = false
    }
    
    override func stopActivityIndicator() {
        super.stopActivityIndicator()
        usernameTextfield.enabled = true
        passwordTextfield.enabled = true
        usernameTextfield.text = ""
        passwordTextfield.text = ""
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
