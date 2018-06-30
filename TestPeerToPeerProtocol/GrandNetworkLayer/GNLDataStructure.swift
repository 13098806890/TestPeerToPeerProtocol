//
//  GNLDataStructure.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/6/30.
//  Copyright © 2018 Xie. All rights reserved.
//

typealias Address = Int32
typealias GNLNode = NFCNetworkNodeProtocol
typealias GNLNodeIdentifier = NFCNodeIdentifier
typealias GNLDomain = GNLNodeIdentifier
typealias GNLAddress = Address

import Foundation

struct GNLFullAddress: Hashable {
    var domain: GNLDomain
    var address: GNLAddress
}

struct GNLDomainPare: Hashable {
    var hashValue: Int = 0
    
    static func == (lhs: GNLDomainPare, rhs: GNLDomainPare) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var leftDomain: GNLDomain
    var rightDomain: GNLDomain
}

struct GNLAddressPare {
    var leftNode: GNLFullAddress
    var rightNode: GNLFullAddress
}

struct GNLFoundPeerAddress {
    var offeredAddress: GNLFullAddress
    var address: GNLFullAddress
}

struct GNLPresentedPeerAddress {
    var node: GNLNode
    var address: GNLFullAddress
}

struct GNLFoundPeersTable {
    var directConnectList: [GNLFoundPeerAddress]
    var directConnectReservedList: [GNLFoundPeerAddress]
    var presentedConnectList: [GNLPresentedPeerAddress]
}
