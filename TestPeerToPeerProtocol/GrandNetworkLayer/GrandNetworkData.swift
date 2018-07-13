//
//  GrandNetworkData.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/13/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

public enum GNLDataType: String {

    case SendClusterFoundPeers

    case Instruction

    case Message
}

class GrandNetworkData: NSObject, NSCoding {

    var dataType: GNLDataType
    var data: Data?

    init(data: Data?, type: GNLDataType) {
        self.data = data
        self.dataType = type
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.dataType.rawValue, forKey: "dataType")
        aCoder.encode(self.data, forKey: "data")
    }

    required init?(coder aDecoder: NSCoder) {
        self.dataType = GNLDataType(rawValue: aDecoder.decodeObject(forKey: "dataType") as! String)!
        self.data = aDecoder.decodeObject(forKey: "data") as? Data
    }
}
