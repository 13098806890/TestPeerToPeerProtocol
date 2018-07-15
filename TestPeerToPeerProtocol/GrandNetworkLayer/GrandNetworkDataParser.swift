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

    static func sendClusterFoundPeersInfo(_ info: [String: [String: String]]) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: info)
        let networkData = GrandNetworkData.init(data: data, type: GNLDataType.SendClusterFoundPeersInfo)
        let transportData = GrandNetworkTransportData.init(data: networkData, sender: nil)
        return NSKeyedArchiver.archivedData(withRootObject: transportData)
    }

    static func parseClusterFoundPeersInfo(_ data: Data) -> [String: [String: String]] {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! [String: [String: String]]
    }
    
    static func sendClusterFoundPeers(_ info: Set<String>) -> Data {
        let data = NSKeyedArchiver.archivedData(withRootObject: info)
        let networkData = GrandNetworkData.init(data: data, type: GNLDataType.SendClusterFoundPeers)
        let transportData = GrandNetworkTransportData.init(data: networkData, sender: nil)
        return NSKeyedArchiver.archivedData(withRootObject: transportData)
    }
    
    static func parseClusterFoundPeers(_ data: Data) -> Set<String> {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! Set<String>
    }



}
