//
//  NuclearTestFoundPeerTableViewCell.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/13/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

protocol NuclearTestFoundPeerTableViewCellDelegate: AnyObject {
    func closeConnectTo(_ name: String)
    func connectTo(_ name: String)
}

class NuclearTestFoundPeerTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var closeConnectButton: UIButton!
    weak var delegate: NuclearTestFoundPeerTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func connect(_ sender: Any) {
        self.delegate?.connectTo(self.nameLabel.text!)
    }

    @IBAction func closeConnect(_ sender: Any) {
        self.delegate?.closeConnectTo(self.nameLabel.text!)
    }

}
