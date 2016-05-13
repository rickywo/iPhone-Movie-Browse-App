//
//  LoadingViewController.swift
//  A1
//
//  Created by Lee Shih ping on 2016/5/9.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var loadingView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSpinner()

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
    
    func startActivityIndicator() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        self.view.addSubview(loadingView)
        
    }
    
    func stopActivityIndicator() {
        let subviews = self.view.subviews
        for subview in subviews {
            if subview.tag == 100 {
                subview.removeFromSuperview()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }
    }
    
    func initializeSpinner() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        loadingView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        loadingView.layer.cornerRadius = 10
        let wait = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        wait.color = UIColor.lightGrayColor().colorWithAlphaComponent(0.8)
        wait.startAnimating()
        wait.hidesWhenStopped = false
        loadingView.addSubview(wait)
        loadingView.center = self.view.center
        loadingView.tag = 100
    }


}
