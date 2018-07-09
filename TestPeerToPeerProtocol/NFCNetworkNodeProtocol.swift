//
//  NFCNetworkNodeProtocol.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

typealias NetworkIdentifier = String
typealias User = String
typealias Network = NetworkIdentifier
typealias NFCNodeIdentifier = NetworkIdentifier

import Foundation
protocol NFCNetworkNodeProtocol {
    
    var delegate: MutilPeerNetworkNodeDelegate {get set}
    var peerID: NFCNodeIdentifier {get}
    var browsers: [NetworkIdentifier:Int] {get}
    var advertisers: [NetworkIdentifier:Int] {get}
    var sessions: [NetworkIdentifier: Int] {get}
    var networks: [NetworkIdentifier: Network] {get}
    var connectedUsers: [NFCNetworkNodeProtocolForTest] {set get}
    var invitationHandler: ((Bool) -> Void)! {set get}
    var foundPeers: [NFCNetworkNodeProtocolForTest] {get}

    func connectedUser(_ user: NFCNetworkNodeProtocolForTest) -> Void
    func createNetwork(_ networkIdentifier: NetworkIdentifier) -> Void
    func advertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopAdvertise(_ networkIdentifier: NetworkIdentifier) -> Void
    func browse(_ networkIdentifier: NetworkIdentifier) -> Void
    func stopBrowse(_ networkIdentifier: NetworkIdentifier) -> Void
    
    func invite(_ user: NFCNetworkNodeProtocolForTest, to netWork: Network) -> Void
    func invitedBy(_ user: NFCNetworkNodeProtocolForTest, from netWork: Network) -> Void
    func invitedResult(_ result: Bool, from node: NFCNetworkNodeProtocolForTest, in network: Network) -> Void
    func disConnectWith(_ user: NFCNetworkNodeProtocolForTest) -> Void
    func lostConnectionWith(_ user: NFCNetworkNodeProtocolForTest) -> Void

    func send(_ data: NSData, toUsers users: [NFCNetworkNodeProtocolForTest])

}

protocol NFCNetworkNodeProtocolForTest: NFCNetworkNodeProtocol{
    var disCoverInfo: [String: String]? {get}
    var unableToBeFoundPeers: [String] {get}
    var onlyFoundPeers: [String] {get}
    func addBlinds(_ blinds: [String]) -> Void
    func send(_ data: NSData, toNode nodes: [NFCNetworkNodeProtocolForTest])
    func receive(_ data: NSData, from node: NFCNetworkNodeProtocolForTest)
    func foundPeersStr() -> String
    func connectedPeersStr() -> String
    func browser(lostPeer peer: NFCNetworkNodeProtocolForTest)
    func browser(foundPeer peer: NFCNetworkNodeProtocolForTest, withDiscoveryInfo info: [String: String]?)
}

protocol MutilPeerNetworkNodeDelegate {
    func disCoverUserInfo() -> [String: String]?
}
