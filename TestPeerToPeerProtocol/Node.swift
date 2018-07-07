//
//  Node.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation


class Node: NFCNetworkNodeProtocolForTest {

    


    //MARK: for testing

    let playGround = NuclearTest.labs
    var unableToBeFoundPeers: [String] = [String]()
    var onlyFoundPeers: [String] = [String]()
    func addBlinds(_ blinds: [String]) {
        self.unableToBeFoundPeers += blinds
    }
    
    func addFinders(_ finders: [String]) {
        self.onlyFoundPeers += finders
    }
    
    func send(_ data: NSData, toNode nodes: [NFCNetworkNodeProtocolForTest]) {
        for node in nodes {
            node.receive(data, from: self)
        }
    }
    
    func receive(_ data: NSData, from node: NFCNetworkNodeProtocolForTest) {
        
    }
    
    //MARK: init methods

    init(name: String, blinds: [String]) {
        self.peerID = name
        self.unableToBeFoundPeers += blinds
    }

    convenience init(name: String) {
        self.init(name: name, blinds: [String]())
    }

    //MARK: NFCNetworkNodeProtocol methods
    var peerID: NFCNodeIdentifier

    var browsers: [NetworkIdentifier : Int] = [NetworkIdentifier : Int]()

    var advertisers: [NetworkIdentifier : Int] = [NetworkIdentifier : Int]()

    var sessions: [NetworkIdentifier : Int] = [NetworkIdentifier : Int]()

    var networks: [NetworkIdentifier : Network] = [NetworkIdentifier : Network]()
    
    var connectedUsers: [NFCNetworkNodeProtocolForTest] = [NFCNetworkNodeProtocolForTest]()

    var invitationHandler: ((Bool) -> Void)!
    
    func createNetwork(_ networkIdentifier: NetworkIdentifier) {
        if playGround.networkNodes[networkIdentifier] == nil {
            playGround.networkNodes[networkIdentifier] = [NFCNetworkNodeProtocolForTest]()
        }
        browsers[networkIdentifier] = 0
        advertisers[networkIdentifier] = 0
    }

    func advertise(_ networkIdentifier: NetworkIdentifier) {
        advertisers[networkIdentifier] = 1
//        let nodes = playGround.networkNodes[networkIdentifier]
//        if let blindNodes = nodes?.filter({ (node) -> Bool in
//            return self.unableToBeFoundPeers.contains(node.peerID)
//        }) {
//            for node in blindNodes {
//                node.addBlinds([self.peerID])
//            }
//        }

        playGround.networkNodes[networkIdentifier]?.append(self)
    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {
        advertisers[networkIdentifier] = 0
        var nodes = playGround.networkNodes[networkIdentifier]
        
        //delete self from playGround
        if nodes != nil {
            nodes = nodes?.filter({ (node) -> Bool in
                return node.peerID == self.peerID
            })
        }
    }

    func browse(_ networkIdentifier: NetworkIdentifier) {
        browsers[networkIdentifier] = 1
    }

    func stopBrowse(_ networkIdentifier: NetworkIdentifier) {
        browsers[networkIdentifier] = 0
    }

    func foundPeers() -> [NFCNetworkNodeProtocolForTest] {
        var nodes = [NFCNetworkNodeProtocolForTest]()
        for key in browsers.keys {
            if browsers[key] == 1 {
                if let addedNode = playGround.foundPeers(node: self, network: key) {
                    nodes += addedNode
                }
            }
        }
        
//        // remove the connected Peer and self
//        return nodes.filter({ (node) -> Bool in
//            return !(self.connectedUsers.contains(where: { (connectedNode) -> Bool in
//                return node.peerID == connectedNode.peerID
//            }) || node.peerID == self.peerID)
//        })
        return nodes
        
    }

    func invite(_ user: NFCNetworkNodeProtocolForTest, to netWork: Network) {
        user.invitedBy(self, from: netWork)
    }

    func invitedBy(_ user: NFCNetworkNodeProtocolForTest, from netWork: Network) {
        user.invitedResult(true, from: self, in: netWork)
        user.connectedUser(self)
    }

    func invitedResult(_ result: Bool, from node: NFCNetworkNodeProtocolForTest, in network: Network) {
        if result {
            self.connectedUsers.append(node)
        }
    }

    func connectedUser(_ user: NFCNetworkNodeProtocolForTest) {
        self.connectedUsers.append(user)
    }

    func send(_ data: NSData, toUsers users: [NFCNetworkNodeProtocolForTest]) {
        for user in users {
            user.receive(data, from: self)
        }
    }


}
