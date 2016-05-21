//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Lee Shih ping on 2016/5/21.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Image {

    @NSManaged var imageData: NSData?
    @NSManaged var key: String?

}
