//
//  Node.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation


class Node: NFCNetworkNodeProtocol {

    var peerID: Any = ""

    var browsers: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var advertisers: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var sessions: [NetworkIdentifier : Any] = [NetworkIdentifier : Any]()

    var networks: [NetworkIdentifier : Network] = [NetworkIdentifier : Network]()
    

    func advertise(_ networkIdentifier: NetworkIdentifier) {

    }

    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) {

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
