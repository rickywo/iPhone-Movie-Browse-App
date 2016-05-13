//
//  LoginViewController.swift
//  A1
//
//  Created by Ricky on 2016/4/7.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: LoadingViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var detailView: UIView!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var userIcon: UIImageView!
    
    let user = CURRENT_USER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LoginViewController.imageTapped(_:)))
        userIcon.userInteractionEnabled = true
        userIcon.addGestureRecognizer(tapGestureRecognizer)
        
        // hide login and logout buttons
        hideViews()
        
        // Check if user is logged in
        if isLoggedIn() {
            // Logged in
            showDetailView()
        } else {
            showLoginView()
        }
        // Do any additional setup after loading the view.
    }
    
    func isLoggedIn() -> Bool {
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && user.authData != nil {
            // Logged in
            return true
        } else {
            return false
        }
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
        user.unauth()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "uid")
        showLoginView()
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
        FIREBASE_REF.authUser(name, password: pw, withCompletionBlock: {(error, authData) -> Void in
            if error == nil {
                NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                print("Login successfully")
                self.showDetailView()
                self.stopActivityIndicator()
                // Something went wrong. :(
            } else {
                self.displayAlertMessage("Login failed");

                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("Handle invalid user")
                    case .InvalidEmail:
                        print("Handle invalid email")
                    case .InvalidPassword:
                        print("Handle invalid password")
                    default:
                        print("Handle default situation")
                    }
                }
            }
        })
    }

    func logedIn(flag: Bool) {
        if flag {
            print("Hide login")
        } else {
            print("Hide Logout")
        }
        loginView.hidden = flag
        detailView.hidden = !flag
    }
    
    func showLoginView() {
        
        detailView.hidden = true
        
        loginView.hidden = false
    }
    
    func showDetailView() {
        print("LoadUserDetail")
        loadUserDetail()
        
        loginView.hidden = true
        
        detailView.hidden = false
        

    }
    
    func hideViews() {
        
        loginView.hidden = true
        
        detailView.hidden = true
        
    }
    
    
    func imageTapped(img: AnyObject)
    {
        // Your action
        print("Picture tapped")
        var imageFromSource = UIImagePickerController()
        imageFromSource.delegate = self
        imageFromSource.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            imageFromSource.sourceType = UIImagePickerControllerSourceType.Camera
            
        } else {
            
            imageFromSource.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
        }
        
        self.presentViewController(imageFromSource, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var temp: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userIcon.image = temp
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func loadUserDetail() {
        print(user.authData.uid)
        emailLabel.text = user.authData.uid
        
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
