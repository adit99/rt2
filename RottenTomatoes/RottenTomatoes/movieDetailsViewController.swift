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
    
    var movieDetails: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        let movie = movieDetails! as NSDictionary
        
        let poster = (movie["posters"] as NSDictionary)["detailed"] as NSString
        let high_res_poster = poster.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
        println("\(high_res_poster)")
        let url = NSURL(string: high_res_poster)
        self.moviePoster.setImageWithURL(url)
        
        let title = (movieDetails!["title"] as NSString)
        let date = " (" + ((movieDetails!["release_dates"] as NSDictionary)["theater"] as NSString) + ")"

        self.movieTitle.text = title + date
        
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

        let synopsis = movie["synopsis"] as NSString
        self.movieSynopsis.text = synopsis

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
