//
//  MainViewController.swift
//  A1
//
//  Created by Lee Shih ping on 2016/5/18.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    //static let dc = DataController()
    let data: DataContainerSingleton = DataContainerSingleton.sharedDataContainer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        fetchImage()
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
    
    func fetchImage() {
        //let moc = DataController().managedObjectContext
        /*let imageFetch = NSFetchRequest(entityName: "Image")
        do{
            let fetchedImage = try data.managedObjectContext!.executeFetchRequest(imageFetch) as! [Image]
           print("fetchedImage: \(fetchedImage.count)")
        } catch {
            fatalError("Failure to fetch image")
        }*/
        let imageFetch = NSFetchRequest(entityName: "Image")
         
         print("Get image from Coredata")
         do{
            let fetchedImage = try data.managedObjectContext!.executeFetchRequest(imageFetch) as! [Image]
            print("fetchedImage: \(fetchedImage.count)")
            for imageMo in fetchedImage {
                print("fetch image from core")
                if let image = UIImage(data: imageMo.imageData! as NSData) {
                        ImageCache.addNewImage(imageMo.key!, image: image)
                }
                let managedObjectData:NSManagedObject = imageMo as NSManagedObject
                data.managedObjectContext!.deleteObject(managedObjectData)
                print("Delete Object in Core data")
                
            }
         } catch {
            fatalError("Failure to fetch image")
         }
    }
    
    func saveImages() {
        for tuple in ImageCache.getStorage()! {
            seedImage(tuple.0, image: tuple.1)
        }
    }
    
    func seedImage ( key: String, image: UIImage ) {
        //let moc = DataController().managedObjectContext
        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0)!)
        let imageMo = NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: try data.managedObjectContext!) as! Image
        
        imageMo.setValue(key, forKey: "key")
        imageMo.setValue(imageData, forKey: "imageData")
        
        do {
            try data.managedObjectContext!.save()
            print("Save image success")
        } catch {
            fatalError("Failure to save context")
        }
    }


}
