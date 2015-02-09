//
//  movieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Aditya Jayaraman on 2/3/15.
//  Copyright (c) 2015 Aditya Jayaraman. All rights reserved.
//

import UIKit

class movieDetailsViewController: UIViewController {

    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieRatingPercentage: UILabel!
    @IBOutlet weak var movieRatingImage: UIImageView!
    
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieSynopsis: UILabel!
    @IBOutlet weak var movieMPAA: UIImageView!
    
    @IBOutlet weak var movieScrollView: UIScrollView!
    
    var movieDetails: NSDictionary?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let movie = movieDetails! as NSDictionary
        
        let poster = (movie["posters"] as NSDictionary)["detailed"] as NSString
        let high_res_poster = poster.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        println("\(high_res_poster)")
        
        let url_low_res = NSURL(string: poster)
        let url = NSURL(string: high_res_poster)
        
        let url_request_low_res = NSURLRequest(URL: url_low_res!)
        let url_request = NSURLRequest(URL: url!)
        let placeholder = UIImage(named: "no_photo")
        
        self.moviePoster.setImageWithURLRequest(url_request_low_res, placeholderImage: placeholder, success: { [weak self] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
            println("Success low res")
            self?.moviePoster.image = image
            self?.moviePoster.setImageWithURLRequest(url_request, placeholderImage: placeholder, success: { [weak self] (request:NSURLRequest!,response:NSHTTPURLResponse!, image:UIImage!) -> Void in
                println("Success high res")
                self?.moviePoster.image = image
                }, failure: { [weak self]
                    (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                    println("Failed to get high res poster")
            })
            }, failure: { [weak self]
                (request:NSURLRequest!,response:NSHTTPURLResponse!, error:NSError!) -> Void in
                println("Failed to get low res poster")
        })

        
        
        let title = (movieDetails!["title"] as NSString)
        let date = " (" + ((movieDetails!["release_dates"] as NSDictionary)["theater"] as NSString) + ")"
        self.movieTitle.text = title + date
        self.navigationItem.title = title

        
        let rating_image_rotten = "http://d3biamo577v4eu.cloudfront.net/static/images/trademark/rotten.png"
        let rating_image_fresh = "http://d3biamo577v4eu.cloudfront.net/static/images/trademark/fresh.png"
        let rating = (movie["ratings"] as NSDictionary)["critics_score"] as Int

        if (rating > 50) {
            let rating_url = NSURL(string: rating_image_fresh)
            self.movieRatingImage.setImageWithURL(rating_url)
        } else {
            let rating_url = NSURL(string: rating_image_rotten)
            self.movieRatingImage.setImageWithURL(rating_url)
        }

        self.movieRatingPercentage.text = rating.description + "%"

        
        let runtime = movie["runtime"] as Int
        self.movieRuntime.text = "Runtime: \(runtime.description) mins"
        
        let mpaa_rating = movie["mpaa_rating"] as NSString
    
        if (mpaa_rating == "PG-13") {
            let pg13 = "http://i.ytimg.com/vi/Sg98FEidkps/maxresdefault.jpg"
            let pg13_url = NSURL(string: pg13)
            self.movieMPAA.setImageWithURL(pg13_url)
        }
        if (mpaa_rating == "R") {
            println("rated r")
            let r = "http://images.sodahead.com/polls/001456021/446881689_12428040071366094694RATED_Rsvghi_xlarge.png"
            let r_url = NSURL(string: r)
            self.movieMPAA.setImageWithURL(r_url)
        }
        if (mpaa_rating == "PG") {
            let pg = "http://unfspinnaker.com/wp-content/uploads/2012/11/pg2.jpg"
            let pg_url = NSURL(string: pg)
            self.movieMPAA.setImageWithURL(pg_url)
        }
        
        let synopsis = movie["synopsis"] as NSString
        self.movieSynopsis.numberOfLines = 0
        self.movieSynopsis.text = synopsis
        self.movieSynopsis.sizeToFit()
        self.movieSynopsis.setNeedsDisplay()
        
        //Disable scrolling but animate the view (below) so that the entire movie synopsis is viewable on click
        var totalHeight = self.movieTitle.frame.size.height + self.movieMPAA.frame.size.height + self.movieSynopsis.frame.size.height + 260
        self.movieScrollView.scrollEnabled = false
        self.movieScrollView.frame.size.height = totalHeight

        println("X:\(self.movieScrollView.frame.origin.x)")
        println("Y:\(self.movieScrollView.frame.origin.y)")
        
    }

    
    @IBAction func onTap(sender: AnyObject) {
        var mv = self.movieScrollView.frame
        var newFrame = mv
        
        if mv.origin.y == 233.0 {
            newFrame.origin.y = 413.0
        } else if mv.origin.y == 413.0 {
            newFrame.origin.y = 233.0
        }
        
       // println("View Height \(mv.size.height)")
       // println("View Y \(mv.origin.y)")

        //Try to adjust the frame based on the height of the view
        /*switch (mv.size.height) {
            case 200...400:
                newFrame.origin.y = 413.0
            case 400...600:
                newFrame.origin.y = 313.0
            case 600...900:
                newFrame.origin.y = 213.0
            default:
                newFrame.origin.y = 213.0
        }*/
        
        UIView.animateWithDuration(0.4,
            animations:{
                self.movieScrollView.frame = newFrame
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
