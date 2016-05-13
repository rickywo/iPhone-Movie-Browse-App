//
//  ImageCache.swift
//  A1
//
//  Created by CY Wu on 2016/5/11.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit

// TODO:
// - Implement LRU Algorithm ( Least-Recently-Used ) to clear unused images from memory
// - Try to make some sort of PriorityQueue out of this..
// - Be awesome. ( Check )

class ImageCache {
    static let sharedInstance = ImageCache()
    
    // private var imageCache: [String : UIImage]!
    
    private var imageCache = LRUCache<String, UIImage>(capacity: 30)
    
    init()  {
        //imageCache = [String : UIImage]()
    }
    
    func find( imageUrl: String ) -> UIImage? {
        if isCached( imageUrl ) {
            let key = stringToBase64( imageUrl )
            return imageCache[key!]
        }
        return nil
    }
    
    func findOrLoadAsync( imageUrl: String, completionHandler: ( image: UIImage! ) -> Void ) {
        if let image = find( imageUrl ) {
            print("Find image")
            completionHandler( image: image )
        }
        else
        {
            print("Dowload from remote")
            self.downloadedImageFrom(imageUrl, complete: { (resultingImage) -> Void in
                if let image = resultingImage {
                    self.addNewImage(imageUrl, image: image)
                    completionHandler( image: image )
                }
            })
        }
    }
    
    
    func downloadedImageFrom(imageUrl: String, complete: (resultingImage: UIImage?) -> Void ) {
        let baseImageURL = "https://image.tmdb.org/t/p/w370\(imageUrl)"
        print(baseImageURL)
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
                    print("Something wrong")
                    return
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                print("Load Image from URL")
                complete(resultingImage: uiImage)
                //self.addNewImage(imageUrl, image: uiImage)
                
            }
        }).resume()
    }
    
    private func addNewImage( imageUrl: String, image: UIImage ) {
        if !isCached( imageUrl ) {
            let key = stringToBase64( imageUrl )
            imageCache[key!] = image
        }
    }
    
    private func isCached( imageUrl: String ) -> Bool {
        if let key = stringToBase64( imageUrl ) {
            if imageCache[key] != nil {
                return true
            }
        }
        return false
    }
    
    private func stringToBase64( string: String ) -> String? {
        let imageData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        return imageData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    }
}
