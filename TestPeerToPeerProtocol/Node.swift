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

    var foundPeers: [NFCNetworkNodeProtocolForTest] = [NFCNetworkNodeProtocolForTest]()
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
    
    func browser(lostPeer peer: NFCNetworkNodeProtocolForTest) {
        self.foundPeers = foundPeers.filter({ (node) -> Bool in
            return node.peerID != peer.peerID
        })
    }
    
    func browser(foundPeer peer: NFCNetworkNodeProtocolForTest) {
        self.foundPeers.append(peer)
    }
    
    //MARK: init methods

    init(name: String) {
        self.peerID = name
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
        playGround.networkNodes[networkIdentifier]?.append(self)
    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {
        advertisers[networkIdentifier] = 0
        var nodes = playGround.networkNodes[networkIdentifier]
        
        //delete self from playGround
        if nodes != nil {
            nodes = nodes?.filter({ (node) -> Bool in
                return node.peerID != self.peerID
            })
        }
    }

    func browse(_ networkIdentifier: NetworkIdentifier) {
        browsers[networkIdentifier] = 1
    }

    func stopBrowse(_ networkIdentifier: NetworkIdentifier) {
        browsers[networkIdentifier] = 0
    }

//    func foundPeers() -> [NFCNetworkNodeProtocolForTest] {
//        var nodes = [NFCNetworkNodeProtocolForTest]()
//        for key in browsers.keys {
//            if browsers[key] == 1 {
//                if let addedNode = playGround.foundPeers(node: self, network: key) {
//                    nodes += addedNode
//                }
//            }
//        }
//
//        return nodes
//
//    }

    func invite(_ user: NFCNetworkNodeProtocolForTest, to netWork: Network) {
        user.invitedBy(self, from: netWork)
    }

    func invitedBy(_ user: NFCNetworkNodeProtocolForTest, from netWork: Network) {
        user.invitedResult(true, from: self, in: netWork)
        self.connectedUser(user)
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
    
    func disConnectWith(_ user: NFCNetworkNodeProtocolForTest) {
        self.playGround.disConnectFrom(user: self, with: user)
    }
    
    func lostConnectionWith(_ user: NFCNetworkNodeProtocolForTest) -> Void {
        self.connectedUsers = self.connectedUsers.filter({ (node) -> Bool in
            return node.peerID != user.peerID
        })
    }
    //MARK: str
    
    func foundPeersStr() -> String {
        var foundPeers = "FoundPeers: "
        for peer in self.foundPeers {
            foundPeers += peer.peerID
            foundPeers += ", "
        }
        
        return foundPeers
    }
    
    func connectedPeersStr() -> String {
        var connectedPeers = "Connected: "
        for peer in self.connectedUsers {
            connectedPeers += peer.peerID
            connectedPeers += ", "
        }
        
        return connectedPeers
    }


}
