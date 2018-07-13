//
//  MultipeerDataParser.swift
//  MPCRevisited
//
//  Created by doxie on 12/21/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation






class GrandNetworkDataParser {

    static func parse(_ data: Data) -> GrandNetworkTransportData {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! GrandNetworkTransportData
    }

    static func sendClusterFoundPeers(_ peers: [String]) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: peers)
        let networkData = GrandNetworkData.init(data: data, type: GNLDataType.SendClusterFoundPeers)
        let transportData = GrandNetworkTransportData.init(data: networkData, sender: nil)
        return NSKeyedArchiver.archivedData(withRootObject: transportData)
    }

    static func parseClusterFoundPeers(_ data: Data) -> [String] {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [String]
    }



}
