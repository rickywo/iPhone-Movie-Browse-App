//
//  MovieModel.swift
//  A1
//
//  Created by Ricky Wu on 2016/4/3.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit

class MovieModel {
    
    var movies: [Movie]
    let tmdbobj = TMDBApi()
    // id: String, title: String, year: String, imageName: String, plot: String, lang: String, rating: Double
    init() {
        self.movies = tmdbobj.getNowPlaying()
        
    }
}
