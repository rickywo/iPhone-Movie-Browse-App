//
//  A1Tests.swift
//  A1Tests
//
//  Created by Ricky on 2016/4/3.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import UIKit
import XCTest

class A1Tests: XCTestCase {
    
    //var csViewController:CustomSearchController?
    //let data: DataContainerSingleton = DataContainerSingleton.sharedDataContainer
    var loginViewController:LoginViewController?
    
    override func setUp() {
        super.setUp()
        loginViewController = LoginViewController()
    //    csViewController = CustomSearchController()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func searchImageTest() {
        // This is an example of a functional test case.
        ImageCache.addNewImage("/inOZqEh8eqAstHaP49pI9rpUro3.jpg", image: UIImage())
        XCTAssert(ImageCache.find("/inOZqEh8eqAstHaP49pI9rpUro3.jpg") != nil, "Pass")
    }
    
    func getImageTest() {
        // This is an example of a functional test case.
        let imageOrigin = UIImage(named: "zootopia")
        ImageCache.addNewImage("/inOZqEh8eqAstHaP49pI9rpUro3.jpg", image: imageOrigin!)
        
        let imageInCache = ImageCache.find("/inOZqEh8eqAstHaP49pI9rpUro3.jpg")
        XCTAssertEqual(imageOrigin, imageInCache)
    }
    
    func imageTobase64strConvertionTest() {
        
        let imageOrigin = UIImage(named: "zootopia")
        let imageData = ImageCache.convertImageToBase64(imageOrigin!)
        let imageConverted = ImageCache.convertBase64ToImage(imageData)
        XCTAssertEqual(imageOrigin, imageConverted)
    
    }
    
    func LRUCacheTest() {
        let lru = LRUCache<Int, Int>(capacity: 30)
        for i:Int in 0...40 {
            lru[i] = i
        }
        XCTAssert(lru.count == 30, "Test failed")
    }
    
    func seedImageTest() {
        
        let image = UIImage(named: "zootopia")
        XCTAssert(ImageCache.seedImage("zootopia", image: image!))
        
    }
    

    
}
