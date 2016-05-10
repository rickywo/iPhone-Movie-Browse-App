//
//  DataContainer.swift
//  A1
//
//  Created by CY Wu on 2016/5/9.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit


/**
 This struct defines the keys used to save the data container singleton's properties to NSUserDefaults.
 This is the "Swift way" to define string constants.
 */
struct DefaultsKeys
{
    static let movie  = "Movie"
    static let cinema  = "Cinema"
}

/**
 :Class:   DataContainerSingleton
 This class is used to save app state data and share it between classes.
 It observes the system UIApplicationDidEnterBackgroundNotification and saves its properties to NSUserDefaults before
 entering the background.
 Use the syntax `DataContainerSingleton.sharedDataContainer` to reference the shared data container singleton
 */

class DataContainerSingleton
{
    static let sharedDataContainer = DataContainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    var movies = [Movie]()
    var cinemas = [Cinema]()
    //------------------------------------------------------------
    
    var goToBackgroundObserver: AnyObject?
    
    init()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        //-----------------------------------------------------------------------------
        //This code reads the singleton's properties from NSUserDefaults.
        //edit this code to load your custom properties
        if let movies = defaults.objectForKey(DefaultsKeys.movie) as! [Movie]? {
            print("Load from NSUserDefault success")
        }
        // cinemas = (defaults.objectForKey(DefaultsKeys.cinema) as! [Cinema]?)!
        //-----------------------------------------------------------------------------
        
        //Add an obsever for the UIApplicationDidEnterBackgroundNotification.
        //When the app goes to the background, the code block saves our properties to NSUserDefaults.
        /*goToBackgroundObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationDidEnterBackgroundNotification,
            object: nil,
            queue: nil)
        {
            (note: NSNotification!) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            //-----------------------------------------------------------------------------
            //This code saves the singleton's properties to NSUserDefaults.
            //edit this code to save your custom properties
            defaults.setObject( self.movies, forKey: DefaultsKeys.movie)
            defaults.setObject( self.cinemas, forKey: DefaultsKeys.cinema)
            //-----------------------------------------------------------------------------
            
            //Tell NSUserDefaults to save to disk now.
            // defaults.synchronize()
        }*/
    }
}