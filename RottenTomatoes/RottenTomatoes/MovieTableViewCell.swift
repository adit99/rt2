//
//  MovieTableViewCell.swift
//  RottenTomatoes
//
//  Created by Aditya Jayaraman on 2/3/15.
//  Copyright (c) 2015 Aditya Jayaraman. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieDesc: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var ratingPercentage: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
