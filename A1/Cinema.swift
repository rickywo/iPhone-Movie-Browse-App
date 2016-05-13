//
//  cinema.swift
//  A1
//
//  Created by Ricky Wu on 2016/4/4.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import Foundation
import UIKit

class Cinema:NSObject {
    var name: String
    var website: String
    var address: String
    var logo: UIImage?
    var rating: Double?
    var movieOn: [Movie]?
    
    init (name: String, website:String, address: String) {
        self.name = name
        self.website = website
        self.address = address
    }
    
    func addMovie( movie: Movie) -> Bool {
        
        var success = true
        for m in movieOn! {
            if m.id == movie.id {
                success = false
            }
        }
        if success {
            movieOn?.append(movie)
            
        }
        return success
    }
    
    func removeMovie(id: String) -> Bool {
        var success = false
        var index = 0
        for _ in movieOn! {
            if movieOn?[index].id == id {
                movieOn?.removeAtIndex(index)
                success = true
            }
            index += 1
        }
        
        return success
    }
    
    func rate(rating: Double) {
        self.rating = rating
    }
    
    func setImage(img: UIImage) {
        self.logo = img
    }
    
}