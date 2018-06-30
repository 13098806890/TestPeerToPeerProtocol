//
//  NFCNetworkNodeProtocol.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

typealias User = Any
typealias Network = AnyHashable
typealias NetworkIdentifier = AnyHashable
typealias NFCNodeIdentifier = AnyHashable

import Foundation
protocol NFCNetworkNodeProtocol {
    
    var peerID: NFCNodeIdentifier {get}
    var browsers: [NetworkIdentifier:Any] {get}
    var advertisers: [NetworkIdentifier:Any] {get}
    var sessions: [NetworkIdentifier: Any] {get}
    var networks: [NetworkIdentifier: Network] {get}

    func advertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func browse(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopBrowse(_ networkIdentifier: NetworkIdentifier) -> Void

    func foundPeers() -> [User]
    func connectedUsers() -> [User]
    func invite(_ user: User, to netWork: Network) -> Void
    func invitedBy(_ user: User, from netWork: Network) -> Bool

    func send(_ data: NSCoding, toUsers users: [User])

}

protocol NFCNetworkNodeProtocolForTest: NFCNetworkNodeProtocol{
    func addBlinds(_ blinds: [String]) -> Void
}
