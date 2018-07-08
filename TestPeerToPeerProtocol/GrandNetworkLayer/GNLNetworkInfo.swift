//
//  GNLNetworkInfo.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/6/30.
//  Copyright © 2018 Xie. All rights reserved.
//
typealias GNLInt = Address

import Foundation

class GNLNetworkInfo {
    
    var leafSize: GNLInt = 2
    var reservedSize: GNLInt = 2
    var nodes: [GNLNodeIdentifier: GrandNetworkLayerNode] = [GNLNodeIdentifier: GrandNetworkLayerNode]()
    var usersInfo: [GNLDomain: GNLDomainUsersInfo] = [GNLDomain: GNLDomainUsersInfo]()
    var foundPeers: [GNLNodeIdentifier: GNLFoundPeersTable] = [GNLNodeIdentifier: GNLFoundPeersTable]()
    var crossDomainConnectedPare: [GNLDomainPare: GNLAddressPare] = [GNLDomainPare: GNLAddressPare]()
    var crossDomainFoundPeers: [GNLDomainPare: GNLAddressPare] = [GNLDomainPare: GNLAddressPare]()
    var connectedPeers: [GNLFullAddress: GrandNetworkLayerNode] = [GNLFullAddress: GrandNetworkLayerNode]()
}
