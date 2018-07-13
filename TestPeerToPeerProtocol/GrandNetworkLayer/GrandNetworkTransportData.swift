//
//  GrandNetworkTransportData.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/13/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

class GrandNetworkTransportData: NSObject, NSCoding {

    var needForward: Bool = false
    var forwardList: [Any]?
    var sender: String?
    var data: GrandNetworkData
    var isUpdateNodesInfo: Bool = false

    init(data: GrandNetworkData, sender: String?) {
        self.data = data
        self.sender = sender
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(needForward, forKey: "needForward")
        aCoder.encode(forwardList, forKey: "forwardList")
        aCoder.encode(sender, forKey: "sender")
        aCoder.encode(data, forKey: "data")
        aCoder.encode(isUpdateNodesInfo, forKey: "isUpdateGroupInfo")
    }

    required init?(coder aDecoder: NSCoder) {
        self.needForward = aDecoder.decodeBool(forKey: "needForward")
        self.forwardList = aDecoder.decodeObject(forKey: "forwardList") as? [Any]
        self.sender = aDecoder.decodeObject(forKey: "sender") as? String
        self.data = aDecoder.decodeObject(forKey: "data") as! GrandNetworkData
        self.isUpdateNodesInfo = aDecoder.decodeBool(forKey: "isUpdateGroupInfo")
    }

}
