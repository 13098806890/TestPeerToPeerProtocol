//
//  GNLClusterSession.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/12/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol GNLClusterSessionDelegate: AnyObject {
    func clusterSession(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) -> Void
    func clusterSession(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
}

class GNLClusterSession: MultipeerNetWorkNode {

    static let suffix = "-c"

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

    init(_ name: String, serviceType: String, delegate: GNLClusterSessionDelegate) {
        self.delegate = delegate
        super.init(GNLClusterSession.clusterName(name), serviceType: serviceType)
    }



    override func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate.clusterSession(session, peer: peerID, didChange: state)
    }

    override func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        delegate.clusterSession(session, didReceive: data, fromPeer: peerID)
    }

}
