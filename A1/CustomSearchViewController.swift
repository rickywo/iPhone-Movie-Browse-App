//
//  CustomSearchViewController.swift
//  A1
//
//  Created by Lee Shih ping on 2016/5/20.
//  Copyright © 2016年 RMIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct movie_t {
    
    var id:String
    var name:String
    
}

class CustomSearchViewController: UIViewController {
    
    var movieArray = [movie_t]()
    var requests:Int = 0
    let data: DataContainerSingleton = DataContainerSingleton.sharedDataContainer

    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var yearTextfield: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        let keyword = titleTextfield.text
        let year = yearTextfield.text
        data.movies.removeAll()
        searchMovieWithKeyword(keyword!, year: year!)
        
    }

    func searchMovieWithKeyword(keyword:String, year:String) {
        
        requests++
        
        Alamofire.request(.GET, "http://www.omdbapi.com/?s=\(keyword)&y=\(year)&plot=short&r=json")
            .responseJSON { response in
                self.requests--
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
                    // print(page)
                    if let movieJsons = page["Search"].array {
                        // to access a field:
                        
                        movieJsons.forEach({ movie in
                            let movieStrc: movie_t = movie_t(id:movie["imdbID"].rawString()!,
                                name:movie["Title"].rawString()!)
                            self.getMovieDetail(movieStrc)
                            //print(movieStrc.name)
                            
                        })
                        print("reloadData here")
                        //self.stopActivityIndicator()
                    } else {
                        print("error parsing")
                    }
                }
        }
    }
    
    func getMovieDetail(moviet: movie_t) {
        
        requests++
        
        let url = "https://api.themoviedb.org/3/find/\(moviet.id)?external_source=imdb_id&api_key=f8efb58c46dfa961ad9eecc412e3f822"
        print(url)
        //print(movie.id)
        
        Alamofire.request(.GET, url)
            .responseJSON { response in
                self.requests--
                guard response.result.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling GET on ")
                    print(response.result.error!)
                    return
                }
                
                if let value = response.result.value {
                    // handle the results as JSON, without a bunch of nested if loops
                    let json = JSON(value)
                    // now we have the results, let's just print them though a tableview would definitely be better UI:
                    // print("The todo is: " + page.description)
                    // return page
                    // print(json)
                    if let movieJsons = json["movie_results"].array {
                        // to access a field:
                        
                        movieJsons.forEach({ movie in
                            let movieObj: Movie = Movie(id:moviet.id,
                                title:movie["original_title"].rawString()!,
                                year:movie["release_date"].rawString()!,
                                imageName:movie["poster_path"].rawString()!,
                                plot:movie["overview"].rawString()!,
                                lang:movie["original_language"].rawString()!,
                                rating:6.0)
                            self.data.movies.append(movieObj)
                            if (self.requests) == 0 {
                                self.performSegueWithIdentifier("FinishSearchSegue", sender: nil)
                            }
                            print(movieObj.title)
                            
                        })
                        print("reloadData here")
                        //self.stopActivityIndicator()
                    } else {
                        print("error parsing")
                    }
                    
                    
                }
        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
