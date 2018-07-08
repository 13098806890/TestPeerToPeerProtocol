//
//  GrandNetworkLayerNode.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

class GrandNetworkLayerNode {
    
    //MARK: Properties
    var isMainNode: Bool = true
    var domain: GNLDomain
    var address: GNLAddress
    var fullAddress: GNLFullAddress
    var node: GNLNode
    var parent: GrandNetworkLayerNode?
    var children: [GNLAddress: GrandNetworkLayerNode] = [GNLAddress: GrandNetworkLayerNode]()
    var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    
    init(node: GNLNode) {
        self.node = node
        domain = node.peerID
        address = 0
        fullAddress = GNLFullAddress(domain: domain, address: address)
    }
    
    private func childStartAddress() -> GNLAddress {
        return address * childrenSize() + 1
    }
    
    private func childrenSize() -> GNLInt {
        return networkInfo.leafSize + networkInfo.reservedSize
    }
    
    
    //MARK : PeerToPeerNetworkProtocol methods
    func createNetwork(_ networkIdentifier: NetworkIdentifier) {
        self.node.createNetwork(networkIdentifier)
    }

    func advertise(_ networkIdentifier: NetworkIdentifier) {
        self.node.advertise(networkIdentifier)
    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {
        self.node.stopAdvertise(networkIdentifier)
    }

    func browse(_ networkIdentifier: NetworkIdentifier) {
        self.node.browse(networkIdentifier)
    }

    func stopBrowse(_ networkIdentifier: NetworkIdentifier) {
        self.node.stopBrowse(networkIdentifier)
    }

    func foundPeers() -> [User] {
        return [User]()
    }

    func connectedUsers() -> [User] {
        return self.node.connectedUsers.map({ (nfcNode) -> String in
            return nfcNode.peerID
        })
    }

    func invite(_ user: User, to netWork: Network) {

    }

    func invitedBy(_ user: User, from netWork: Network) {
        //always accept
        
    }

    func disconnectWithUser(_ user: User, in netWork: Network) {

    }

    func quit(_ network: Network) {

    }

    func disbandNetwork(_ network: Network) {

    }

    func kickOffUser(_ user: User, fromNetwork network: Network) {

    }

    func sendData(data: NSCoding, toUser user: User, inNetwork network: Network) -> Bool {
        return true
    }
    
    //MARK: GrandNetworkLayer
    func invite(_ node: GrandNetworkLayerNode, to netWork: Network) {
        self.node.invite(node.node, to: netWork)
    }
    
    func invitedBy(_ node: GrandNetworkLayerNode, from netWork: Network) {
        self.node.invitedBy(node.node, from: netWork)
    }
    
    func invitedResult(_ result: Bool, from node: GNLNode, in network: Network) {
        self.node.invitedResult(result, from: node, in: network)
    }
    
    
    

}
