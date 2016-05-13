//
//  Image+CoreDataProperties.swift
//  A1
//
//  Created by Lee Shih ping on 2016/5/11.
//  Copyright © 2016年 RMIT. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var name: String?
    @NSManaged var imageData: NSData?

}
