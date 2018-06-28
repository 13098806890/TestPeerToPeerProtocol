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
    func addBlinds(_ blinds: [String]) {
        self.unableToBeFoundPeers += blinds
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
    var peerID: Any

    var browsers: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var advertisers: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var sessions: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var networks: [NetworkIdentifier : Network] = [NetworkIdentifier : Network]()

    func advertise(_ networkIdentifier: NetworkIdentifier) {
        let nodes = playGround.networkNodes[networkIdentifier]
        if nodes == nil {
            playGround.networkNodes[networkIdentifier] = [NFCNetworkNodeProtocolForTest]()
        }
        if let blindNodes = nodes?.filter({ (node) -> Bool in
            return self.unableToBeFoundPeers.contains(node.peerID as! String)
        }) {
            for node in blindNodes {
                node.addBlinds([self.peerID as! String])
            }
        }

        playGround.networkNodes[networkIdentifier]?.append(self)
    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {
        var nodes = playGround.networkNodes[networkIdentifier]
        if nodes != nil {
            nodes = nodes?.filter({ (node) -> Bool in
                return node.peerID as! String != self.peerID as! String
            })
        }
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

    func send(_ data: NSCoding, toUsers users: [User]) {

    }


}
