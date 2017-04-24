//
//  ScanCell.swift
//  EOB-Reader
//
//  Created by Samuel Cheng on 3/4/17.
//  Copyright © 2017 Samuel Cheng. All rights reserved.
//

import UIKit

// custom class for each cell containing scan results
class ScanCell: UITableViewCell {
    
    var mytvc : RecentScansVC?
    @IBOutlet weak var thumbImageView : UIImageView!
    @IBOutlet weak var scanNameLabel : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        scanNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
