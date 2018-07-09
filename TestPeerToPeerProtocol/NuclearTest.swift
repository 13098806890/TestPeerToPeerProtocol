//
//  NuclearTest.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation

class NuclearTest {
    static let labs = NuclearTest()
    static let testNetwork = "NuclearTestPlayground"
    var allTestNodesName: [String] = [String]()
    var networkNodes: [NetworkIdentifier:[NFCNetworkNodeProtocolForTest]] = [NetworkIdentifier:[NFCNetworkNodeProtocolForTest]]()
    var allNodes: [String: NFCNetworkNodeProtocolForTest] = [String: NFCNetworkNodeProtocolForTest]()
    var allGNLNode: [GrandNetworkLayerNode] = [GrandNetworkLayerNode]()
    
    func addNode(name: String, blinds: [String], finders: [String]) -> Bool {
        if allTestNodesName.contains(name) {
            return false
        } else {
            let node = Node.init(name: name)
            node.createNetwork(NuclearTest.testNetwork)
            node.browse(NuclearTest.testNetwork)
            node.advertise(NuclearTest.testNetwork)
            self.allTestNodesName.append(name)
            if blinds.count > 0 {
                node.addBlinds(blinds)
            }
            if finders.count > 0 {
                node.addFinders(finders)
            }
            for oldNode in allNodes.values {
                addFoundPeer(to: oldNode, with: node)
            }
            node.foundPeers = foundPeers(node: node)
            allNodes[name] = node
            let gnlNode = GrandNetworkLayerNode.init(node: node)
            allGNLNode.append(gnlNode)
        }
        
        return true
    }
    
    func addFoundPeer(to node: NFCNetworkNodeProtocolForTest, with foundPeer: NFCNetworkNodeProtocolForTest) {
        if !node.foundPeers.contains(where: { (foundPeerNode) -> Bool in
            return foundPeerNode.peerID == foundPeer.peerID
        }) {
            if node.onlyFoundPeers.count > 0 {
                if node.onlyFoundPeers.contains(foundPeer.peerID) {
                    if foundPeer.onlyFoundPeers.count > 0 {
                        if foundPeer.onlyFoundPeers.contains(node.peerID) {
                            if !node.unableToBeFoundPeers.contains(foundPeer.peerID) && !foundPeer.unableToBeFoundPeers.contains(node.peerID) {
                                node.browser(foundPeer: foundPeer, withDiscoveryInfo: foundPeer.disCoverInfo)
                            }
                        }
                    } else {
                        if !node.unableToBeFoundPeers.contains(foundPeer.peerID) && !foundPeer.unableToBeFoundPeers.contains(node.peerID) {
                            node.browser(foundPeer: foundPeer, withDiscoveryInfo: foundPeer.disCoverInfo)
                        }
                    }
                }
                
            } else {
                if foundPeer.onlyFoundPeers.count > 0 {
                    if foundPeer.onlyFoundPeers.contains(node.peerID) && !node.unableToBeFoundPeers.contains(foundPeer.peerID) && !foundPeer.unableToBeFoundPeers.contains(node.peerID) {
                        node.browser(foundPeer: foundPeer, withDiscoveryInfo: foundPeer.disCoverInfo)
                    }
                } else {
                    if !node.unableToBeFoundPeers.contains(foundPeer.peerID) && !foundPeer.unableToBeFoundPeers.contains(node.peerID) {
                        node.browser(foundPeer: foundPeer, withDiscoveryInfo: foundPeer.disCoverInfo)
                    }
                }
            }
        }
    }
    
    func lostFoundPeer(to node: NFCNetworkNodeProtocolForTest, with lostPeer: NFCNetworkNodeProtocolForTest) {
        if node.foundPeers.contains(where: { (foundPeerNode) -> Bool in
            return foundPeerNode.peerID == lostPeer.peerID
        }) {
            node.browser(lostPeer: lostPeer)
        }
    }
    
    func foundPeers(node: NFCNetworkNodeProtocolForTest, network: NetworkIdentifier) -> [NFCNetworkNodeProtocolForTest]? {
        if let nodes = self.networkNodes[network] {
            
            if node.onlyFoundPeers.count > 0 {
                return nodes.filter({ (otherNode) -> Bool in
                    return node.onlyFoundPeers.contains(where: { (finder) -> Bool in
                        if let finderNode = self.allNodes[finder] {
                            return finder == otherNode.peerID && !finderNode.unableToBeFoundPeers.contains(otherNode.peerID)
                        } else {
                            return finder == otherNode.peerID
                        }
                    })
                })
            }
            return nodes.filter({ (otherNode) -> Bool in
                if otherNode.onlyFoundPeers.count > 0 {
                    return !node.connectedUsers.contains(where: { (connectedNode) -> Bool in
                        return otherNode.peerID == connectedNode.peerID
                    }) && otherNode.onlyFoundPeers.contains(node.peerID)
                } else {
                    return !node.connectedUsers.contains(where: { (connectedNode) -> Bool in
                        return otherNode.peerID == connectedNode.peerID
                    }) && otherNode.peerID != node.peerID && !node.unableToBeFoundPeers.contains(where: { (blind) -> Bool in
                        return otherNode.peerID == blind
                    }) && !otherNode.unableToBeFoundPeers.contains(node.peerID)
                }
            })
        }
        return nil
    }
    
    func foundPeers(node: NFCNetworkNodeProtocolForTest) -> [NFCNetworkNodeProtocolForTest] {
        if let foundPeers = foundPeers(node: node, network: NuclearTest.testNetwork) {
            return foundPeers
        } else {
            return [NFCNetworkNodeProtocolForTest]()
        }
    }
    
    func connectTo(name: String, from node: NFCNetworkNodeProtocolForTest) {
        if let addedNode = self.allNodes[name] {
            if node.foundPeers.contains(where: { (foundPeer) -> Bool in
                return foundPeer.peerID == name
            }) {
                node.invite(addedNode, to: NuclearTest.testNetwork)
            }
        }
    }
    
    func disConnectFrom(user: NFCNetworkNodeProtocolForTest, with: NFCNetworkNodeProtocolForTest) {
        if user.connectedUsers.contains(where: { (node) -> Bool in
            node.peerID == with.peerID
        }) && with.connectedUsers.contains(where: { (node) -> Bool in
            node.peerID == user.peerID
        }) {
            user.lostConnectionWith(with)
            with.lostConnectionWith(user)
        }
    }
    
    func disConnectWith(user: String, node: NFCNetworkNodeProtocolForTest) {
        if let disConnectedNode = allNodes[user] {
            disConnectFrom(user: node, with: disConnectedNode)
        }
    }
}

