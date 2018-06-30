//
//  GrandNetworkLayerNode.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

class GrandNetworkLayerNode: PeerToPeerNetworkProtocol {
    
    //MARK: Properties
    var isMainNode: Bool = true
    var domain: GNLDomain
    var address: GNLAddress
    var fullAddress: GNLFullAddress
    var node: GNLNode
    var parent: GNLNode?
    var children: [GNLAddress: GNLNode] = [GNLAddress: GNLNode]()
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
        
    }

    func advertise(_ networkIdentifier: NetworkIdentifier) {

    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {

    }

    func browse(_ networkIdentifier: NetworkIdentifier) {

    }

    func stopBrowse(_ networkIdentifier: NetworkIdentifier) {

    }

    func foundPeers() -> [User] {
        return [User]()
    }

    func connectedUsers() -> [User] {
        return [User]()
    }

    func invite(_ user: User, to netWork: Network) {

    }

    func invitedBy(_ user: User, from netWork: Network) -> Bool {
        return true
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

}
