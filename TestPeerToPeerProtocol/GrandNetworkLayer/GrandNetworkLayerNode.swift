//
//  GrandNetworkLayerNode.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/28/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class GrandNetworkLayerNode: GNLParentSessionDelegate, GNLClusterSessionDelegate {

    //MARK: Properties
    var isMainNode: Bool = true
    var displayName: String
    var serviceType: String
    var domain: GNLDomain
    var address: GNLAddress
    var fullAddress: GNLFullAddress
    var children: [GNLAddress: MultipeerNetWorkNode] = [GNLAddress: MultipeerNetWorkNode]()
    var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    var foundPeersInfo: [String: [String: String]] = [String: [String: String]]()
    var foundPeers: [String] = [String]()
    var _usersInNetwork: [String] = [String]()
    var clusterFoundPeers:[String: [String]] = [String: [String]]()

    lazy var cluster: GNLClusterSession = GNLClusterSession.init(displayName, serviceType: serviceType, delegate: self)
    lazy var parent: GNLParentSession = GNLParentSession.init(displayName, serviceType: serviceType, delegate: self)

    var closePeers: [String]?

    init(name: String, service: String = "GNL-test") {
        address = 0
        domain = name
        displayName = name
        serviceType = service
        fullAddress = GNLFullAddress(domain: domain, address: address)
        _usersInNetwork.append(displayName)
    }

    func start() {
        self.parent.start()
        self.cluster.start()
    }

    func stop() {
        self.parent.stop()
        self.cluster.stop()
    }

    func ableToBuildClusterConnection(_ name: String) -> Bool {
        for foundPeers in clusterFoundPeers.values {
            if !foundPeers.contains(name) {
                return false
            }
        }
        
        return true
    }

    func inviteToCluster(name: String){
        if let peerID = parent.clusterPeerID(GNLClusterSession.clusterName(name)) {
            self.cluster.invite(peer: peerID, withContext: nil, timeout: 1000)
        }
    }

    private func childStartAddress() -> GNLAddress {
        return address * childrenSize() + 1
    }
    
    private func childrenSize() -> GNLInt {
        return networkInfo.leafSize + networkInfo.reservedSize
    }

    //MARK: GNLSessionDelegate
    func GNLNodeName(_ peersDisplayName: String) -> String {
       return GNLClusterSession.normalName(peersDisplayName)
    }
    
    func usersBeFound() -> [String] {
        return foundPeers
    }
    
    func usersInNetwork() -> [String] {
        return _usersInNetwork
    }

    func connectedUsers() -> [String] {
        return _usersInNetwork.filter({ (name) -> Bool in
            return name != displayName
        })
    }
    
    //MARK: GNLParentSessionDelegate
    func parentBrowser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        if info == nil {
            foundPeersInfo[peerID] = [String: String]()
        } else {
            foundPeersInfo[peerID] = info
        }
        sendClusterFoundPeers()
        sendClusterFoundPeersInfo()
    }
    
    func parentBrowser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: String) {
        if let index = foundPeers.index(of: peerID) {
            foundPeers.remove(at: index)
        }
        foundPeersInfo.removeValue(forKey: peerID)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let transportData = GrandNetworkDataParser.parse(data)
        let networkData = transportData.data
        switch networkData.dataType {
        case .SendClusterFoundPeersInfo:
            if let foundPeersData = networkData.data {
                let foundPeersInfo = GrandNetworkDataParser.parseClusterFoundPeersInfo(foundPeersData)
                var foundPeers = [String]()
                for key in foundPeersInfo.keys {
                    foundPeers.append(key)
                }
                clusterFoundPeers[GNLNodeName(peerID.displayName)] = foundPeers
            }
            NuclearPlayground.labs.reloadView()
        case .SendClusterFoundPeers:
            if let foundPeersData = networkData.data {
                let foundPeers = GrandNetworkDataParser.parseClusterFoundPeers(foundPeersData)
                self.foundPeers += foundPeers
                clusterFoundPeers[GNLNodeName(peerID.displayName)] = foundPeers
            }
            NuclearPlayground.labs.reloadView()
        default: break
            
        }
    }

    func connectedWithPeer(_ peer: String) {
        _usersInNetwork.append(peer)
        foundPeersInfo.removeValue(forKey: peer)
        foundPeers = foundPeers.filter({ (name) -> Bool in
            return name != peer
        })

        // send to all other Nodes
    }

    //MARK: GNLClusterSessionDelegate and methods
    func clusterSession(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let nodeName = GNLNodeName(peerID.displayName)
        switch state {
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            connectedWithPeer(nodeName)
            deleteClusterFoundPeer(nodeName)
            sendClusterFoundPeersInfo()
            sendClusterFoundPeers()
            NuclearPlayground.labs.connected(node: cluster, with: nodeName)
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
        case MCSessionState.notConnected:
            print("Lost connection to session: \(session)")
        }
    }
    
    func clusterSession(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.session(session, didReceive: data, fromPeer: peerID)
    }

    func sendClusterFoundPeersInfo() {
        let transportData = GrandNetworkDataParser.sendClusterFoundPeersInfo(foundPeersInfo)
        do {
            try cluster.session.send(transportData, toPeers: cluster.session.connectedPeers, with: .reliable)
        } catch {
            print(error)
        }
    }
    
    func sendClusterFoundPeers() {
        let transportData = GrandNetworkDataParser.sendClusterFoundPeers(foundPeers)
        do {
            try cluster.session.send(transportData, toPeers: cluster.session.connectedPeers, with: .reliable)
        } catch {
            print(error)
        }
    }

    func deleteClusterFoundPeer(_ name: String) {
        for (peer, peers) in clusterFoundPeers {
            clusterFoundPeers[peer] = peers.filter({ (foundPeer) -> Bool in
                return foundPeer != name
            })
        }
    }
    

    //MARK: GrandNetworkLayer


    //MARK: Str
    func foundPeersStr() -> String {
        var foundPeersStr = "FoundPeers: "
        for (index, peer) in foundPeers.enumerated() {
            foundPeersStr += peer
            if index != foundPeers.count - 1 {
                foundPeersStr += ", "
            }
        }
        
        return foundPeersStr
    }

    func connectedPeersStr() -> String {
        var connectedUsersStr = "ConnectedUsers: "
        for (index, peer) in connectedUsers().enumerated() {
            connectedUsersStr += peer
            if index != _usersInNetwork.count - 1 {
                connectedUsersStr += ", "
            }
        }

        return connectedUsersStr
    }

}
