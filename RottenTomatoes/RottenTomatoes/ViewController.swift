//
//  ViewController.swift
//  RottenTomatoes
//
//  Created by Aditya Jayaraman on 2/2/15.
//  Copyright (c) 2015 Aditya Jayaraman. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

//    @IBOutlet weak var moviesTableView: UITableView!
        
    var moviesArray: NSArray?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //moviesTableView.rowHeight = 100.00
        //moviesTableView.dataSource = self
        self.navigationItem.title = "Booyakasha"
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(self.refreshControl!, atIndex: 0)

    }
    
    override func viewDidAppear(animated: Bool) {
    
        super.viewDidAppear(animated)
        reload()
    }
    
    
    func reload() {
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        SVProgressHUD.show()

        let YourApiKey = "nxdq2a74ehrv2r8bvjqxvcwp"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            if error == nil {
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                self.moviesArray = dictionary["movies"] as? NSArray
                self.tableView.reloadData()
            } else {
                var label = UILabel(frame: CGRectMake(0, 0, 200, 100))
                label.center = CGPointMake(180, 24)
                label.textAlignment = NSTextAlignment.Center
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
        
        let movie = self.moviesArray![indexPath.row] as NSDictionary
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
        println("Hello")
        if let array = moviesArray {
            return array.count
        } else {
            return 0
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
                    let movie = self.moviesArray![indexPath.row] as NSDictionary
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
    
}

