//
//  NuclearPlayground.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/9/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

protocol NotificationForTest {
    func foundPeer(node: MultipeerNetWorkNode, peerID: String, withDiscoveryInfo info: [String : String]?) -> Void
    func connected(node: MultipeerNetWorkNode, with peer: String) -> Void
}

class NuclearPlayground: NotificationForTest {
    static let labs = NuclearPlayground()
    static let serviceType = "PlayGround"
    var allNodesName: [String] = [String]()
    var allNodes: [String: MultipeerNetWorkNode] = [String: MultipeerNetWorkNode]()
    var allGNLNode: [GrandNetworkLayerNode] = [GrandNetworkLayerNode]()
    open var oberservers: [NotificationForTest] = [NotificationForTest]()

    func startAdvertiser(node: MultipeerNetWorkNode) {
        self.allNodesName.append(node.name())
        self.allNodes[node.name()] = node
    }

    func addNode(name: String, blinds: [String], finders: [String]) -> Bool {
        if allNodesName.contains(name) {
            return false
        } else {
            let node = MultipeerNetWorkNode.init(name)
            if blinds.count > 0 {
                node.addBlinds(blinds)
            }
            if finders.count > 0 {
                node.addFinders(finders)
            }
            node.createBrowser(NuclearPlayground.serviceType)
            node.createAdvertiser(NuclearPlayground.serviceType)
            self.allNodesName.append(name)
            self.allNodes[name] = node
            let GNLNode = GrandNetworkLayerNode.init(node: node)
            self.allGNLNode.append(GNLNode)
        }

        return true
    }

    func shouldFound(peerID: String, blinds: [String]?, finders: [String]?) -> Bool {
        if finders != nil && finders!.count > 0 && blinds != nil && blinds!.count > 0 {
            if finders!.contains(peerID) && !blinds!.contains(peerID) {
                return true
            }
        } else if finders != nil && finders!.count > 0 {
            if finders!.contains(peerID) {
                return true
            }
        } else if blinds != nil && blinds!.count > 0 {
            if !blinds!.contains(peerID) {
                return true
            }
        } else if (finders == nil || finders?.count == 0) && (blinds == nil || blinds?.count == 0) {
            return true
        }

        return false
    }


    //MARK: NotificationForTest
    func foundPeer(node: MultipeerNetWorkNode, peerID: String, withDiscoveryInfo info: [String : String]?) {
        for oberserver in oberservers {
            oberserver.foundPeer(node: node, peerID: peerID, withDiscoveryInfo: info)
        }
    }

    func connected(node: MultipeerNetWorkNode, with peer: String) {
        for oberserver in oberservers {
            oberserver.connected(node: node, with: peer)
        }
    }
}
