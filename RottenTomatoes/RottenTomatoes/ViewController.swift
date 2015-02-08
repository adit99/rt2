//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Aditya Jayaraman on 2/2/15.
//  Copyright (c) 2015 Aditya Jayaraman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

//    @IBOutlet weak var moviesTableView: UITableView!
        
    var moviesArray: NSArray?
    var searchArray: NSArray?
    var isSearching: Bool?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load")
        self.isSearching = false
        self.navigationItem.title = "Top DVD's"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(self.refreshControl!, atIndex: 0)
        reload()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.searchBar.text.isEmpty  == false) {
            println("View did appear is searching")
            self.isSearching = true
        }
        self.tableView.reloadData()
    }
    
    
    func reload() {

        SVProgressHUD.show()

        let YourApiKey = "nxdq2a74ehrv2r8bvjqxvcwp"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let RottenTomatoesSearchURLString = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=" + YourApiKey
        var searchURL = RottenTomatoesURLString + "&limit=50"
        
        let request = NSMutableURLRequest(URL: NSURL(string: searchURL)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            if error == nil {
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                    self.moviesArray = dictionary["movies"] as? NSArray
                    self.tableView.reloadData()
            } else {
                //self.tableView.hidden = true
                let imageName = "network_error.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 125, y: 175, width: 20, height: 20)
                self.view.addSubview(imageView)
                var label = UILabel(frame: CGRectMake(150, 150, 150, 75))
                label.text = "Network Error!"
                self.view.addSubview(label)
            }

            SVProgressHUD.dismiss()
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        SVProgressHUD.show()
        
        println("Called  tableview for row index")
        var movie = self.moviesArray![indexPath.row] as NSDictionary

        if self.isSearching == true {
            println("Searching")
            movie = self.searchArray![indexPath.row] as NSDictionary
        }
        
        //println("\(movie)")
        //let movie = self.moviesArray![indexPath.row] as NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier("codepath.mycell") as MovieTableViewCell
        cell.movieTitleLabel.text = movie["title"] as NSString
        
        let poster = (movie["posters"] as NSDictionary)["detailed"] as NSString
        let high_res_poster = poster.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        //println("\(high_res_poster)")
        let url_low_res = NSURL(string: poster)
        let url = NSURL(string: high_res_poster)
        cell.movieImage.setImageWithURL(url_low_res)
        
        //try better way
        let url_request = NSURLRequest(URL: url!)
        let placeholder = UIImage(named: "no_photo")
        cell.movieImage.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { [weak cell] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            cell?.movieImage.image = image
            SVProgressHUD.dismiss()
            //println("Success")
            }, failure: { [weak cell]
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
              //  println("Failed")
                SVProgressHUD.dismiss()
        })
            
        
        let synopsis = movie["synopsis"] as NSString
        cell.movieDesc.text = synopsis
        
        let mpaa_rating = movie["mpaa_rating"] as NSString
        cell.movieRating.text = mpaa_rating
        
        let rating_image_rotten = "http://d3biamo577v4eu.cloudfront.net/static/images/trademark/rotten.png"
        let rating_image_fresh = "http://d3biamo577v4eu.cloudfront.net/static/images/trademark/fresh.png"
        
        let rating = (movie["ratings"] as NSDictionary)["critics_score"] as Int
        
        if (rating > 50) {
            let rating_url = NSURL(string: rating_image_fresh)
            cell.ratingImage.setImageWithURL(rating_url)
        } else {
            let rating_url = NSURL(string: rating_image_rotten)
            cell.ratingImage.setImageWithURL(rating_url)
        }
        
        cell.ratingPercentage.text = rating.description
        
        let runtime = movie["runtime"] as Int
        cell.movieRuntime.text = "Runtime: \(runtime.description) mins"

        return cell;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Called  tableview for number of rows in section")

        if self.isSearching == true {
            if let array = self.searchArray {
                println("Searching through \(array.count) entries")
                return array.count
            }
            else {
                return 0
            }
        } else {
            if let array = self.moviesArray {
                println("Searching through \(array.count) entries")
                return array.count
            } else {
                return 0
            }
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("Bye")
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did tap row \(indexPath.row)")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "showMovieControllerSegue" {
                let cell = sender as MovieTableViewCell
                if let indexPath = tableView.indexPathForCell(cell) {
                    var movie = self.moviesArray![indexPath.row] as NSDictionary
                    if (self.isSearching == true) {
                        movie = self.searchArray![indexPath.row] as NSDictionary
                    }
                    let moviesController = segue.destinationViewController as movieDetailsViewController
                    moviesController.movieDetails = movie
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                }
            }
        }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        reload()
        self.refreshControl?.endRefreshing()
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        
        if (searchText.isEmpty) {
            self.isSearching = false
            self.tableView.reloadData()
            return
        }
        
        var sArray = [NSDictionary]()
        if let array = self.moviesArray {
            for i in 0...(array.count-1) {
                let movie = array[i] as NSDictionary
                let title = movie["title"] as NSString
                if (((title.lowercaseString) as NSString).containsString(searchText.lowercaseString) == true) {
                    println("\(searchText!) exists in \(title)" )
                    sArray += [movie]
                }
            }
        }
        //println("New Search array \(sArray)")
        self.searchArray = sArray
        self.isSearching = true
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        println("done editing")
        self.isSearching = false
    }
}

