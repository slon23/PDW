//
//  SumUserLogTableViewCell.swift
//  PDW
//
//  Created by Sanjin on 27/02/2017.
//  Copyright © 2017 Sanjin. All rights reserved.
//

import UIKit

class SumUserLogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fluidSum: UILabel!
    @IBOutlet weak var dateSum: UILabel!
    @IBOutlet weak var fluidUnitLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
