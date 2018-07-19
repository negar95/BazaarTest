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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func moreInfoAction(_ sender: Any) {
    }
    
}
