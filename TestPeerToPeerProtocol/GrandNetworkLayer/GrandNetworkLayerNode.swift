//
//  GrandNetworkLayerNode.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GrandNetworkLayerNode: GNLParentSessionDelegate {

    //MARK: Properties
    var isMainNode: Bool = true
    var displayName: String
    var serviceType: String
    var domain: GNLDomain
    var address: GNLAddress
    var fullAddress: GNLFullAddress
    var children: [GNLAddress: MultipeerNetWorkNode] = [GNLAddress: MultipeerNetWorkNode]()
    var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    var foundPeers: [String] = [String]()

    lazy var cluster: GNLClusterSession = GNLClusterSession.init(displayName, serviceType: serviceType)
    lazy var parent: GNLParentSession = GNLParentSession.init(displayName, serviceType: serviceType, delegate: self)

    var closePeers: [String]?
    var _usersInNetwork: [String] = [String]()

    init(name: String, service: String = "GNL-test") {
        address = 0
        domain = name
        displayName = name
        serviceType = service
        fullAddress = GNLFullAddress(domain: domain, address: address)
        _usersInNetwork.append(displayName)
        start()
    }

    func start() {
        self.parent.start()
        self.cluster.start()
    }

    func stop() {
        self.parent.stop()
        self.cluster.stop()
    }

    private func childStartAddress() -> GNLAddress {
        return address * childrenSize() + 1
    }
    
    private func childrenSize() -> GNLInt {
        return networkInfo.leafSize + networkInfo.reservedSize
    }

    //MARK: GNLParentSessionDelegate
    func GNLNodeName(_ peersDisplayName: String) -> String {
        if peersDisplayName.hasSuffix("-c") {

            return String(peersDisplayName.prefix(peersDisplayName.count-2))
        }

        return peersDisplayName
    }

    func usersInNetwork() -> [String] {
        return _usersInNetwork
    }

    func browser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: String) {
        if let index = foundPeers.index(of: peerID) {
            foundPeers.remove(at: index)
        }

    }
    //MARK: GrandNetworkLayer
    func sendFoundPeerInstruction(peerId: String) {

    }
    
    

}
