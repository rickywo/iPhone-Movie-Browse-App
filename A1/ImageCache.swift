//
//  ImageCache.swift
//  A1
//
//  Created by CY Wu on 2016/5/11.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// TODO:
// - Implement LRU Algorithm ( Least-Recently-Used ) to clear unused images from memory
// - Try to make some sort of PriorityQueue out of this..
// - Be awesome. ( Check )

class ImageCache {
    
    static let sharedInstance = ImageCache()
    
    // private var imageCache: [String : UIImage]!
    static var moc:NSManagedObjectContext?
    
    private static var imageCache = LRUCache<String, UIImage>(capacity: 30)
    
    
    init()  {
    }
    
    static func find( imageUrl: String ) -> UIImage? {
        if isCached( imageUrl ) {
            let key =  imageUrl 
            return imageCache[key]
        }
        return nil
    }
    
    static func findOrLoadAsync( imageUrl: String, completionHandler: ( image: UIImage! ) -> Void ) {
        if let image = find( imageUrl ) {
            print("Found")
            completionHandler( image: image )
        }
        else
        {
            self.downloadedImageFrom(imageUrl, complete: { (resultingImage) -> Void in
                if let image = resultingImage {
                    self.addNewImage(imageUrl, image: image)
                    completionHandler( image: image )
                }
            })
        }
    }
    
    
    static func downloadedImageFrom(imageUrl: String, complete: (resultingImage: UIImage?) -> Void ) {
        let baseImageURL = "https://image.tmdb.org/t/p/w370\(imageUrl)"
        guard
            let url = NSURL(string: baseImageURL)
            else {
                
                return
        }
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let uiImage = UIImage(data: data)
                else {
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        complete(resultingImage: UIImage(named: "placeholder"))
                        //self.addNewImage(imageUrl, image: uiImage)
                        
                    }
                    return
                    //return
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                complete(resultingImage: uiImage)
                //self.addNewImage(imageUrl, image: uiImage)
                
            }
        }).resume()
    }
    
    static func addNewImage( imageUrl: String, image: UIImage ) {
        print(imageUrl)
        if !isCached( imageUrl ) {
            let key = imageUrl
            imageCache[key] = image
        }
    }
    
    static func isCached( imageUrl: String ) -> Bool {
        let key = imageUrl
        if imageCache[key] != nil {
            return true
        }
        return false
    }
    
    static func stringToBase64( string: String ) -> String? {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    // convert images into base64 and keep them into string
    
    static func convertImageToBase64(image: UIImage) -> String {
        
        let imageData = UIImagePNGRepresentation(image)
        let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        return base64String
        
    }// end convertImageToBase64
    
    
    // convert images into base64 and keep them into string
    
    static func convertBase64ToImage(base64String: String) -> UIImage? {
        
        if let decodedData:NSData? = NSData(base64EncodedString: base64String, options: []) {
        
            let decodedimage = UIImage(data: decodedData!)
            return decodedimage!
        }
        return nil
        
    }// end convertBase64ToImage
    
    static func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func ResizeImage(image: UIImage, ratio: CGFloat) -> UIImage {
        let size = image.size
        let widthRatio  = ratio
        let heightRatio = ratio
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    static func getStorage() -> [(String, UIImage)]? {
        var tuples = [(String, UIImage)]()
        let array = imageCache.getAll()
        for e in array {
            tuples.append((e.0, e.1))
        }
        return tuples
    }
    
    static func fetchImage() {
        
        if moc == nil {
            moc = DataController().managedObjectContext
        }
        
        let imageFetch = NSFetchRequest(entityName: "Image")
        do{
            let fetchedImage = try moc!.executeFetchRequest(imageFetch) as! [Image]
            print("fetchedImage: \(fetchedImage.count)")
        } catch {
            fatalError("Failure to fetch image")
        }
        /*let imageFetch = NSFetchRequest(entityName: "Image")
        
        print("Get image from Coredata")
        do{
            let fetchedImage = try moc.executeFetchRequest(imageFetch) as! [Image]
            print("fetchedImage: \(fetchedImage.count)")
            for imageMo in fetchedImage {
                print("fetch image from core")
                if let image = UIImage(data: imageMo.imageData! as NSData) {
                    addNewImage(imageMo.key!, image: image)
                }
            }
        } catch {
            fatalError("Failure to fetch image")
        }*/
    }
    
    static func saveImages() {
        for image in imageCache.getAll() {
            print("save image \(image.0)")
            seedImage(image.0, image: image.1)
        }
    }
    
    static func seedImage ( key: String, image: UIImage ) -> Bool {
        
        var result = true
       
        let data: DataContainerSingleton = DataContainerSingleton.sharedDataContainer

        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        let imageMo = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: moc!) as! Image
        
        imageMo.setValue(key, forKey: "key")
        imageMo.setValue(imageData, forKey: "imageData")
        
        do {
            try data.managedObjectContext!.save()
            print("Save image success")
        } catch {
            result = false
            fatalError("Failure to save context")
        }
        
        return result
    }

}
