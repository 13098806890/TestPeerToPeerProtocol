//
//  GrandNetworkLayerNode.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

class GrandNetworkLayerNode: MultipeerTransportLayerDelegate {

    //MARK: Properties
    var isMainNode: Bool = true
    var displayName: String
    var domain: GNLDomain
    var address: GNLAddress
    var cluster: MultipeerNetWorkNode
    var parent: MultipeerNetWorkNode
    var fullAddress: GNLFullAddress
    var children: [GNLAddress: MultipeerNetWorkNode] = [GNLAddress: MultipeerNetWorkNode]()
    var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    var closePeers: [String]?

    init(displayName: String) {
        self.address = 0
        self.domain = displayName
        self.displayName = displayName
        self.parent = MultipeerNetWorkNode.init(displayName)


    }

    init(node: MultipeerNetWorkNode) {
        self.node = node
        domain = node.name()
        address = 0
        fullAddress = GNLFullAddress(domain: domain, address: address)
        node.delegate = self
    }
    
    private func childStartAddress() -> GNLAddress {
        return address * childrenSize() + 1
    }
    
    private func childrenSize() -> GNLInt {
        return networkInfo.leafSize + networkInfo.reservedSize
    }

    //MARK: MultipeerTransportLayerDelegate

    func browser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) {
        
    }
    
    //MARK: GrandNetworkLayer
    func sendFoundPeerInstruction(peerId: String) {

    }
    
    

}
