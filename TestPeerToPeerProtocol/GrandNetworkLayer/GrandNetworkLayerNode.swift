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
    var domain: GNLDomain
    var address: GNLAddress
    var node: MultipeerNetWorkNode
    var fullAddress: GNLFullAddress
    var parent: GrandNetworkLayerNode?
    var children: [GNLAddress: GrandNetworkLayerNode] = [GNLAddress: GrandNetworkLayerNode]()
    var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    
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
