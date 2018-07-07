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
            allNodes[name] = node
        }
        
        return true
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
    
    func foundPeers(node: NFCNetworkNodeProtocolForTest) -> [NFCNetworkNodeProtocolForTest]? {
        return foundPeers(node: node, network: NuclearTest.testNetwork)
    }
}

