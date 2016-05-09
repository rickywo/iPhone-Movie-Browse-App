//
//  TMDBApi.swift
//  A1
//
//  Created by Lee Shih ping on 2016/5/7.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
 */



public class TMDBApi {
    //let baseURL = "https://api.themoviedb.org/3/movie/550?api_key=f8efb58c46dfa961ad9eecc412e3f822"
    
    
    func getNowPlaying() -> [Movie]{
        var movies = [Movie]()
        
        Alamofire.request(.GET, "http://api.themoviedb.org/3/movie/now_playing?page=1&api_key=f8efb58c46dfa961ad9eecc412e3f822")
            .responseJSON { response in
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on ")
                    print(response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let page = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    // print("The todo is: " + page.description)
                    // return page
                    if let movieJsons = page["results"].array {
                        // to access a field:
                        movieJsons.forEach({ movie in
                            var movieObj: Movie = Movie(id:movie["imdb_id"].rawString()!,
                                title:movie["original_title"].rawString()!,
                                year:movie["release_date"].rawString()!,
                                imageName:movie["poster_path"].rawString()!,
                                plot:movie["plot"].rawString()!,
                                lang:movie["original_language"].rawString()!,
                                rating:6.0)
                            //print(movieObj.title)
                            movies.append(movieObj)
                        });
                    } else {
                        print("error parsing /todos/1")
                    }
                }
        }
        for o in movies {
            print(o.title)
        }
        return movies
    }
    
    public static func createImageURLString(image imageFile: String, imageWidth width: Int)->String!{
        // https://image.tmdb.org/t/p/w370/tsOMBg7V9fwL09NcLl4YjzrGZ1K.jpg
        let baseImageURL = "https://image.tmdb.org/t/p/w\(width)/\(imageFile)"
        
        return baseImageURL
    }
}