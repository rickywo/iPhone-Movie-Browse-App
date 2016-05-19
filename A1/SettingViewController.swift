//
//  SettingViewController.swift
//  A1
//
//  Created by Ricky on 2016/4/7.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let textToShare = "Check out our website about it!"
    
    let siteAdress = "http://www.R-studio.com"
    let helpTitle = "Help"
    let helpText = "Please visit http://www.R-studio.com"
    
    let feedbackEmail = "R-studio@rmit.edu.au"
    let feedbackSubject = "App Feedback"
    
    let userAgreementTitle = "Terms and Conditions"
    let userAgreementText = "END-USERS LICSENCE AGREEMENTS Thank you for selecting SILVERADO. The application has been developed by R-Studio."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareTapped(sender: AnyObject) {
            
            if let site = NSURL(string: siteAdress) {
                let objectsToShare = [textToShare, site]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                
                //New Excluded Activities Code
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
                //
                
                activityVC.popoverPresentationController?.sourceView = sender as! UIView
                self.presentViewController(activityVC, animated: true, completion: nil)
            }
    }
    
    
    @IBAction func feedbackTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([feedbackEmail])
        mailComposerVC.setSubject(feedbackSubject)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func helpTapped(sender: AnyObject) {
        displayAlertMessage(helpTitle, userMessage: helpText)
    }
    
    @IBAction func termsTapped(sender: AnyObject) {
        displayAlertMessage(userAgreementTitle, userMessage: userAgreementText)
    }
    
    func displayAlertMessage(title: String, userMessage:String)
    {
        
        let alertCtl = UIAlertController(title:title, message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let successAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default, handler:nil);
        
        alertCtl.addAction(successAction);
        
        self.presentViewController(alertCtl, animated:true, completion: nil);
        
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
