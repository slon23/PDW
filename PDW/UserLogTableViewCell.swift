//
//  UserLogTableViewCell.swift
//  PDW
//
//  Created by Sanjin on 02/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit

class UserLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fluid: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var inputDate: UILabel!
    @IBOutlet weak var unit: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
