//
//  NuclearTestNodeTableViewCell.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/7/7.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class NuclearTestNodeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var parentLabel: UILabel!
    @IBOutlet weak var foundPeersLabel: UILabel!
    @IBOutlet weak var childrenLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
