//
//  PeerToPeerNetworkProtocol.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

typealias User = Any
typealias Network = Any
typealias NetworkIdentifier = String

import Foundation
protocol PeerToPeerNetworkProtocol {
    func createNetwork(_ networkIdentifier: NetworkIdentifier) -> Void
    func advertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func browse(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopBrowse(_ networkIdentifier: NetworkIdentifier) -> Void
    func foundPeers() -> [User]
    func connectedUsers() -> [User]
    func invite(_ user: User, to netWork: Network) -> Void
    func invitedBy(_ user: User, from netWork: Network) -> Bool
    func disconnectWithUser(_ user: User, in netWork: Network) -> Void
    func quit(_ network: Network) -> Void
    func disbandNetwork(_ network: Network) -> Void
    func kickOffUser(_ user: User, fromNetwork network: Network)-> Void
    func sendData(data: NSCoding, toUser user: User, inNetwork network: Network) -> Bool
}
