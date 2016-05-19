//
//  Movie.swift
//  A1
//
//  Created by Ricky Wu on 2016/4/3.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit


class Movie:NSObject, NSCoding {
    
    var id: String?
    var title: String?
    var year: String?
    var image: UIImage?
    var imageName: String?
    var plot: String?
    var lang: String?
    var rating: Double?
    
    init(id: String, title: String, year: String, imageName: String, plot: String, lang: String, rating: Double) {
        self.id = id
        self.title = title
        self.year = year
        self.plot = plot
        self.lang = lang
        self.rating = rating
        self.imageName = imageName
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let id = self.id {
            aCoder.encodeObject(id, forKey: "id")
        }
        if let title = self.title {
            aCoder.encodeObject(title, forKey: "title")
        }
        if let year = self.year {
            aCoder.encodeObject(year, forKey: "year")
        }
        if let plot = self.plot {
            aCoder.encodeObject(plot, forKey: "plot")
        }
        if let rating = self.rating {
            aCoder.encodeObject(rating, forKey: "rating")
        }
        if let imageName = self.imageName {
            aCoder.encodeObject(imageName, forKey: "imageName")
        }
    }
    
    override init() {
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.id = aDecoder.decodeObjectForKey("id") as? String
        
        self.title = aDecoder.decodeObjectForKey("title") as? String
        
        self.year = aDecoder.decodeObjectForKey("year") as? String
        
        self.plot = aDecoder.decodeObjectForKey("plot") as? String
        
        self.rating = aDecoder.decodeObjectForKey("rating") as? Double
        
        self.imageName = aDecoder.decodeObjectForKey("imageName") as? String
        
    }
}