//
//  SearchTVC.swift
//  BazaarTest
//
//  Created by negar on 97/Mordad/01 AP.
//  Copyright © 1397 negar. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var searchTitleLbl: UILabel!

    var searchEntity = Search()
    let coreData = CoreDataHelper()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        coreData.deleteSingleFromCoreData(search: searchEntity)
        self.layer.opacity = 0.5
        self.deleteBtn.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
