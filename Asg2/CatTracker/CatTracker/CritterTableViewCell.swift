//
//  CritterTableViewCell.swift
//  CatTracker
//
//  Created by 1155032539 on 11/3/2017.
//  Copyright © 1155032539 901lab. All rights reserved.
//

import UIKit

class CritterTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var details: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
