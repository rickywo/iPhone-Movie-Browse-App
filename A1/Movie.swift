//
//  Movie.swift
//  A1
//
//  Created by Ricky Wu on 2016/4/3.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit


class Movie {
    var id: String
    var title: String
    var year: String
    var image: UIImage?
    var imageName: String
    var plot: String
    var lang: String
    var rating: Double

    
    init(id: String, title: String, year: String, imageName: String, plot: String, lang: String, rating: Double) {
        self.id = id
        self.title = title
        self.year = year
        self.plot = plot
        self.lang = lang
        self.rating = rating
        self.imageName = imageName
    }
}