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
    var displayName: String
    fileprivate var isMainNode: Bool = true
    fileprivate var serviceType: String
    fileprivate var domain: GNLDomain
    fileprivate var address: GNLAddress
    fileprivate var fullAddress: GNLFullAddress
    fileprivate var children: [GNLAddress: MultipeerNetWorkNode] = [GNLAddress: MultipeerNetWorkNode]()
    fileprivate var networkInfo: GNLNetworkInfo = GNLNetworkInfo()
    var foundPeersInfo: [String: [String: String]] = [String: [String: String]]()
    var foundPeers: Set<String> = Set<String>()
    var _usersInNetwork: Set<String> = Set<String>()
    var clusterFoundPeers:[String: Set<String>] = [String: Set<String>]()

    lazy var cluster: GNLClusterSession = GNLClusterSession.init(displayName, serviceType: serviceType, delegate: self)
    lazy var parent: GNLParentSession = GNLParentSession.init(displayName, serviceType: serviceType, delegate: self)

    var closePeers: [String]?

    init(name: String, service: String = "GNL-test") {
        address = 0
        domain = name
        displayName = name
        serviceType = service
        fullAddress = GNLFullAddress(domain: domain, address: address)
        _usersInNetwork.insert(displayName)
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
    
    func usersBeFound() -> Set<String> {
        return foundPeers
    }
    
    func usersInNetwork() -> Set<String> {
        return _usersInNetwork
    }
    
    func peersFoundByCluster() -> Set<String> {
        var peers: Set<String> = Set<String>.init()
        for foundPeers in self.clusterFoundPeers.values {
            if foundPeers.count == 0 {
                return peers
            } else {
                if peers.isEmpty {
                    peers = peers.union(foundPeers)
                } else {
                    peers = peers.intersection(foundPeers)
                }
            }
        }
        
        return peers
    }
    
    func peersFoundByClusterDic() -> [String: String]? {
        
    }
    
    //MARK: GNLParentSessionDelegate
    func parentBrowser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) {
        foundPeers.insert(peerID)
        if info == nil {
            foundPeersInfo[peerID] = [String: String]()
        } else {
            foundPeersInfo[peerID] = info
        }
        sendClusterFoundPeers()
        sendClusterFoundPeersInfo()
    }
    
    func parentBrowser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: String) {
        foundPeers.remove(peerID)
        foundPeersInfo.removeValue(forKey: peerID)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let transportData = GrandNetworkDataParser.parse(data)
        let networkData = transportData.data
        switch networkData.dataType {
        case .SendClusterFoundPeersInfo:
            if let foundPeersData = networkData.data {
                let foundPeersInfo = GrandNetworkDataParser.parseClusterFoundPeersInfo(foundPeersData)
                var foundPeers = Set<String>()
                for key in foundPeersInfo.keys {
                    foundPeers.insert(key)
                }
                clusterFoundPeers[GNLNodeName(peerID.displayName)] = foundPeers
            }
            NuclearPlayground.labs.reloadView()
        case .SendClusterFoundPeers:
            if let foundPeersData = networkData.data {
                let foundPeers = GrandNetworkDataParser.parseClusterFoundPeers(foundPeersData)
                self.foundPeers = self.foundPeers.union(foundPeers)
                clusterFoundPeers[GNLNodeName(peerID.displayName)] = foundPeers
            }
            NuclearPlayground.labs.reloadView()
        default: break
            
        }
    }

    func connectedWithPeer(_ peer: String) {
        _usersInNetwork.insert(peer)
        foundPeersInfo.removeValue(forKey: peer)
        foundPeers.remove(peer)

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

    func connectedUsers() -> Set<String> {
        return _usersInNetwork.filter({ (name) -> Bool in
            return name != displayName
        })
    }

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
