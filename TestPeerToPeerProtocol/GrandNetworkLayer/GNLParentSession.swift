//
//  GNLParentSession.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/12/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol GNLParentSessionDelegate: AnyObject {
    func browser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) -> Void
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: String) -> Void
    func usersInNetwork() -> [String]
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

    //MARK : - MCNearbyServiceBrowserDelegate
    override func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {

        let GNLNodeName = delegate.GNLNodeName(peerID.displayName)
        if delegate.usersInNetwork().contains(GNLNodeName) {
            if foundPeers[peerID.displayName] == nil {
                foundPeers[peerID.displayName] = peerID
            }
        }
        //For Test
        if info != nil {
            let peerBlinds = info!["blinds"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            let peerFinders = info!["finders"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            if playGround.shouldFound(peerID: peerID.displayName, blinds: blindsPeers, finders: finderPeers) && playGround.shouldFound(peerID: self.peer.displayName, blinds:peerBlinds , finders: peerFinders) {
                foundPeers[peerID.displayName] = peerID
                delegate.browser(foundPeer: peerID.displayName, withDiscoveryInfo: info)
                playGround.foundPeer(node: self, peerID: peerID.displayName, withDiscoveryInfo: info)
            }
        } else {
            if playGround.shouldFound(peerID: peerID.displayName, blinds: blindsPeers, finders: finderPeers) {
                foundPeers[peerID.displayName] = peerID
                delegate.browser(foundPeer: peerID.displayName, withDiscoveryInfo: info)
                playGround.foundPeer(node: self, peerID: peerID.displayName, withDiscoveryInfo: info)
            }
        }
    }

    override func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        if foundPeers[peerID.displayName] != nil {
            foundPeers.removeValue(forKey: peerID.displayName)
        }
        let GNLNodeName = delegate.GNLNodeName(peerID.displayName)
        if delegate.usersInNetwork().contains(GNLNodeName) {
            delegate.browser(browser, lostPeer: peerID.displayName)
        }
    }


}
