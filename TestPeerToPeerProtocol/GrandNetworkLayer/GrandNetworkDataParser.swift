//
//  MultipeerDataParser.swift
//  MPCRevisited
//
//  Created by doxie on 12/21/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation

public enum MultipeerDataType: String {

    case nodesInfo

    case message
}

class GrandNetworkData: NSObject, NSCoding {

    var dataType: MultipeerDataType
    var data: NSCoding?

    init(data: NSCoding?, type: MultipeerDataType) {
        self.data = data
        self.dataType = type
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.dataType.rawValue, forKey: "dataType")
        aCoder.encode(self.data, forKey: "data")
    }

    required init?(coder aDecoder: NSCoder) {
        self.dataType = MultipeerDataType(rawValue: aDecoder.decodeObject(forKey: "dataType") as! String)!
        self.data = aDecoder.decodeObject(forKey: "data") as? NSCoding
    }
}

class GrandNetworkTransportData: NSObject, NSCoding {

    var needForward: Bool = false
    var forwardList: [Any]?
    var sender: Any!
    var data: GrandNetworkData
    var isUpdateNodesInfo: Bool = false

    init(data: GrandNetworkData, sender: Any) {
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
        self.sender = aDecoder.decodeObject(forKey: "sender") as! Any
        self.data = aDecoder.decodeObject(forKey: "data") as! MultipeerData
        self.isUpdateNodesInfo = aDecoder.decodeBool(forKey: "isUpdateGroupInfo")
    }

}

class MultipeerDataParser {

}
