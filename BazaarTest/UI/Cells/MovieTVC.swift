//
//  MovieTVC.swift
//  BazaarTest
//
//  Created by negar on 97/Tir/28 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class MovieTVC: UITableViewCell {

    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var movieReleaseDateLbl: UILabel!
    @IBOutlet weak var movieInfoLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!
    
    
    var isExpanded : Bool = false
    var row : IndexPath = []


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.movieInfoLbl.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
