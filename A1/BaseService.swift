//
//  BaseService.swift
//  A1
//
//  Created by CY Wu on 2016/5/9.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import Foundation
import Firebase

var BASE_URL = "https://silverado.firebaseio.com"
var FIREBASE_REF = Firebase(url: BASE_URL)

var CURRENT_USER:Firebase {
    
    var uid: String
    if let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String? {
        uid = userID
    }
    else {
        uid = "12345"
    }
    let currentUser = FIREBASE_REF.childByAppendingPath("users").childByAppendingPath(uid)
    
    return currentUser!
}
