//
//  Node.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation
protocol MultipeerNetWorkPeerToPeerProtocol {
}

protocol NearFieldPeerToPeerNode {
    var connectedNodes: [NearFieldPeerToPeerNode]{get}
    func startBrowser()
    func stopBrowser()
    func startAdvertiser()
    func stopAdvertiser()
    func sendInvitation(to node: NearFieldPeerToPeerNode)
    func receiveInvitation(from node: NearFieldPeerToPeerNode)
    func handleInvitation(_ allow: Bool, from node: NearFieldPeerToPeerNode)
    func connectedWith(_ node: NearFieldPeerToPeerNode)
    func lostConnectedWith(_ node: NearFieldPeerToPeerNode)
    func nearbyNodes() -> [NearFieldPeerToPeerNode]
}

protocol NearFieldPeerToPeerTransportProtocol: NearFieldPeerToPeerNode {
    var isMainNode: Bool {get}
    var address: Int64 {get}
    var usedAddresses: [Int64] {get}
    var nodesInfo: [Int64: NearFieldPeerToPeerNode] {get}
    var leafSize: Int64 {get}

    func receiveInvitation(from node: NearFieldPeerToPeerNode)
    func sendTransportData(data transportData: MultipeerTransportData, toPeers targetPeer: [NearFieldPeerToPeerNode]) -> Bool
    func handle(data transportData: MultipeerTransportData)
    func path(from node: NearFieldPeerToPeerNode, to target:NearFieldPeerToPeerNode) -> [NearFieldPeerToPeerNode]
    func updateNodeInfo()
    
}

class TestNode: TreeProtocol {

}

class TreeProtocol: NearFieldPeerToPeerTransportProtocol {

    var usedAddresses: <Int64> = [0]

    var isMainNode: Bool = true

    var address: Int64 = 0

    var nodesInfo: [Int64 : NearFieldPeerToPeerNode] = [:]

    var leafSize: Int64 = 2

    var connectedNodes: [NearFieldPeerToPeerNode] = [NearFieldPeerToPeerNode]()

    //mark need subclass to overwrite
    func startBrowser() {

    }

    func stopBrowser() {

    }

    func startAdvertiser() {

    }

    func stopAdvertiser() {

    }

    //TransportProtocol
    func sendInvitation(to node: NearFieldPeerToPeerNode) {
        node.receiveInvitation(from: self)
    }

    func receiveInvitation(from node: NearFieldPeerToPeerNode) {
        let isAllowedToconnected = true
        if isAllowedToconnected {
            self.isMainNode = false
            self.stopAdvertiser()
            node.handleInvitation(true, from: self)
        } else {
            node.handleInvitation(false, from: self)
        }

    }

    func handleInvitation(_ allow: Bool, from node:NearFieldPeerToPeerNode) {
        if allow {
            node.connectedWith(self)
            self.connectedWith(node)
        }
    }

    func connectedWith(_ node: NearFieldPeerToPeerNode) {
        self.connectedNodes.append(node)
    }

    func lostConnectedWith(_ node: NearFieldPeerToPeerNode) {

    }

    func nearbyNodes() -> [NearFieldPeerToPeerNode] {

    }

    func sendTransportData(data transportData: MultipeerTransportData, toPeers targetPeer: [NearFieldPeerToPeerNode]) -> Bool {

    }

    func handle(data transportData: MultipeerTransportData) {

    }

    func path(from node: NearFieldPeerToPeerNode, to target: NearFieldPeerToPeerNode) -> [NearFieldPeerToPeerNode] {

    }

    func updateNodeInfo() {

    }

}
