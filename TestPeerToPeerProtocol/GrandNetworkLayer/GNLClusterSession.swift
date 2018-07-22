//
//  GNLClusterSession.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/12/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol GNLClusterSessionDelegate: GNLSessionDelegate {
    func clusterSession(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) -> Void
    func clusterSession(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
}

class GNLClusterSession: MultipeerNetWorkNode {

    //MARK: static methods
    static let suffix = "-c"
    static let clusterFoundPeersKey = "clusterFoundPeersKey"

    static func clusterName(_ name: String) -> String {
        return name + GNLClusterSession.suffix
    }

    static func normalName(_ name: String) -> String {
        if name.hasSuffix(GNLClusterSession.suffix) {
            return String(name.prefix(name.count-GNLClusterSession.suffix.count))
        }

        return name
    }
    
    var delegate: GNLClusterSessionDelegate
    var clusterFoundPeers:[String: Set<String>] = [String: Set<String>]()

    init(_ name: String, serviceType: String, delegate: GNLClusterSessionDelegate) {
        self.delegate = delegate
        super.init(GNLClusterSession.clusterName(name), serviceType: serviceType)
    }

    func ableToBuildClusterConnection(_ name: String) -> Bool {
        for foundPeers in clusterFoundPeers.values {
            if !foundPeers.contains(name) {
                return false
            }
        }
        
        if let info = delegate.foundPeersInfo[name] {
            if let clusterFoundPeersStr = info[GNLClusterSession.clusterFoundPeersKey] {
                let peerSet = self.peersFromFoundByClusterStr(clusterFoundPeersStr)
                if peerSet.contains(name) {
                    return true
                }
            }
        }
    
        return false
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
    
    func peersFoundByClusterStr() -> String? {
        let peers = peersFoundByCluster()
        if peers.isEmpty {
            return nil
        } else {
            var peersString = ""
            for (index, peer) in peers.enumerated() {
                peersString += peer
                if index != peers.count {
                    peersString += ","
                }
            }
            return peersString
        }
    }
    
    func peersFromFoundByClusterStr(_ peers: String) -> Set<String> {
        let peersArray = peers.components(separatedBy: CharacterSet.init(charactersIn: ","))
        var peersSet = Set<String>.init()
        for peer in peersArray {
            if !peer.isEmpty {
                peersSet.insert(peer)
            }
        }
        
        return peersSet
    }

    func deleteClusterFoundPeer(_ name: String) {
        for (peer, peers) in clusterFoundPeers {
            clusterFoundPeers[peer] = peers.filter({ (foundPeer) -> Bool in
                return foundPeer != name
            })
        }
    }
    
    override func discoverInfo() -> [String : String]? {
        var info: [String: String]?
        if let superInfo = super.discoverInfo() {
            if info == nil {
                info = [String: String]()
            }
            for (key, value) in superInfo {
                info![key] = value
            }
        }
        if let peersFoundByClusterStr = peersFoundByClusterStr() {
            if info == nil {
                info = [String: String]()
            }
            info![GNLClusterSession.clusterFoundPeersKey] = peersFoundByClusterStr
        }
        
        return info
    }
    
    //MARK : MCSessionDelegate
    override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate.clusterSession(session, peer: peerID, didChange: state)
    }

    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate.clusterSession(session, didReceive: data, fromPeer: peerID)
    }

}
