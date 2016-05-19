//
//  MovieTableViewController.swift
//  A1
//
//  Created by Ricky on 2016/4/3.
//  Copyright (c) 2016年 RMIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class MovieTableViewController: LoadingViewController, UITableViewDelegate, UITableViewDataSource {
    
    let data: DataContainerSingleton = DataContainerSingleton.sharedDataContainer
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(loadingView)
        if(data.movies.count == 0 ) {
            self.getNowPlaying()}
        else {
            tableView.reloadData()
        }
        
        //fetchImage()
        
        //moveTableView.delegate = self
        //moveTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return data.movies.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as UITableViewCell
        let movie = data.movies[indexPath.row] as Movie?
        cell.textLabel?.text = movie!.title
        cell.detailTextLabel?.text = movie!.year
         //else {
        
        if movie!.image != nil {
            
            cell.imageView?.image = movie!.image
            
        } else if movie != nil {
            if let t = movie?.imageName {
                ImageCache.findOrLoadAsync(t, completionHandler: { (image) -> Void in
                    movie!.image = image
                    cell.imageView?.image = movie!.image
                    self.tableView.reloadData()
                })
            }
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let destination = segue.destinationViewController as? MovieUIViewController {
            if let index = tableView.indexPathForSelectedRow?.row {
                destination.movie = data.movies[index]
                print(data.movies[index].title)
                print(data.movies[index].lang)
                print(data.movies[index].plot)
            }
        }
    }
    
    func getNowPlaying() {
        self.startActivityIndicator()
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
                            let movieObj: Movie = Movie(id:movie["imdb_id"].rawString()!,
                                title:movie["original_title"].rawString()!,
                                year:movie["release_date"].rawString()!,
                                imageName:movie["poster_path"].rawString()!,
                                plot:movie["overview"].rawString()!,
                                lang:movie["original_language"].rawString()!,
                                rating:6.0)
                            //print(movieObj.title)
                            //self.downloadedImageFrom(link: movieObj.imageName!, movie: movieObj)
                            self.data.movies.append(movieObj)
                            
                            
                        })
                        print("reloadData here")
                        self.tableView.reloadData()
                        self.stopActivityIndicator()
                    } else {
                        print("error parsing")
                    }
                }
        }
    }
    
    func downloadedImageFrom(link link:String, movie:Movie) {
        let baseImageURL = "https://image.tmdb.org/t/p/w370\(link)"
        guard
            let url = NSURL(string: baseImageURL)
            else {return}
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let uiImage = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                movie.image = uiImage
                print("Load Image from URL")
                self.tableView.reloadData()
            }
        }).resume()
    }
}

