//
//  MachineTableViewCell.swift
//  Image Machine Hans
//
//  Created by Hans Christian Yulianto on 05/03/20.
//  Copyright © 2020 Hans Christian Yulianto. All rights reserved.
//

import UIKit

class MachineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
