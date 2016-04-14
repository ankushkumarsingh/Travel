//
//  TableViewCell.swift
//  imageFilter
//
//  Created by citiadmin on 3/12/16.
//  Copyright © 2016 ankush. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var departArrivalAirport: UILabel!
    @IBOutlet weak var departArrivalTime: UILabel!
    
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var flightClass: UILabel!
    
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var airlineCode: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
