//
//  GNLParentSession.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/12/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol GNLSessionDelegate: AnyObject {
    func usersBeFound() -> [String]
    func usersInNetwork() -> [String]
}

protocol GNLParentSessionDelegate: GNLSessionDelegate {
    func parentBrowser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) -> Void
    func parentBrowser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: String) -> Void
    func GNLNodeName(_ peersDisplayName: String) -> String
}

class GNLParentSession: MultipeerNetWorkNode {
    var delegate: GNLParentSessionDelegate

    init(_ name: String, serviceType: String, delegate: GNLParentSessionDelegate) {
        self.delegate = delegate
        super.init(name)
        createBrowser(serviceType)
        createAdvertiser(serviceType)
    }

    func clusterPeerID(_ name: String) -> MCPeerID? {
        return foundPeers[name]
    }

    //MARK : - MCNearbyServiceBrowserDelegate
    override func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

        foundPeers[peerID.displayName] = peerID
        let GNLNodeName = delegate.GNLNodeName(peerID.displayName)
        if delegate.usersInNetwork().contains(GNLNodeName) {
            return
        }
        if delegate.usersBeFound().contains(GNLNodeName) {
            return
        }
        //For Test
        if info != nil {
            let peerBlinds = info!["blinds"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            let peerFinders = info!["finders"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            if playGround.shouldFound(peerID: GNLNodeName, blinds: blindsPeers, finders: finderPeers) && playGround.shouldFound(peerID: self.peer.displayName, blinds:peerBlinds , finders: peerFinders) {
                delegate.parentBrowser(foundPeer: GNLNodeName, withDiscoveryInfo: info)
                playGround.foundPeer(node: self, peerID: GNLNodeName, withDiscoveryInfo: info)
            }
        } else {
            if playGround.shouldFound(peerID: GNLNodeName, blinds: blindsPeers, finders: finderPeers) {
                delegate.parentBrowser(foundPeer: GNLNodeName, withDiscoveryInfo: info)
                playGround.foundPeer(node: self, peerID: GNLNodeName, withDiscoveryInfo: info)
            }
        }
    }

    override func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if foundPeers[peerID.displayName] != nil {
            foundPeers.removeValue(forKey: peerID.displayName)
        }
        let GNLNodeName = delegate.GNLNodeName(peerID.displayName)
        if delegate.usersBeFound().contains(GNLNodeName) {
            delegate.parentBrowser(browser, lostPeer: peerID.displayName)
        }
    }


}
