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
    func reloadView() -> Void
}

class NuclearPlayground: NotificationForTest {
    static let labs = NuclearPlayground()
    var allNodesName: [String] = [String]()
    var allGNLNode: [GrandNetworkLayerNode] = [GrandNetworkLayerNode]()
    open var oberservers: [NotificationForTest] = [NotificationForTest]()

    func addNode(name: String, blinds: [String], finders: [String]) -> Bool {
        if allNodesName.contains(name) {
            return false
        } else {
            self.allNodesName.append(name)
            let GNLNode = GrandNetworkLayerNode.init(name: name)
            if blinds.count > 0 {
                GNLNode.parent.addBlinds(blinds)
                GNLNode.cluster.addBlinds(blinds)
            }
            if finders.count > 0 {
                GNLNode.parent.addFinders(finders)
                GNLNode.cluster.addFinders(finders)
            }
            self.allGNLNode.append(GNLNode)
            GNLNode.start()
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
    
    func reloadView() {
        for oberserver in oberservers {
            oberserver.reloadView()
        }
    }
}
