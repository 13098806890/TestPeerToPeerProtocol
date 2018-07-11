//
//  MultipeerNetWorkNode.swift
//  TestMultipeerConnectivity
//
//  Created by doxie on 12/20/17.
//  Copyright © 2017 Xie. All rights reserved.
//

import MultipeerConnectivity

protocol MultipeerTransportLayerDelegate {
    func browser(foundPeer peerID: String, withDiscoveryInfo info: [String : String]?) -> Void
}

class MultipeerNetWorkNode: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {

    //MARK: just for playground test
    let playGround = NuclearPlayground.labs
    open var blindsPeers: [String] = [String]()
    open var finderPeers: [String] = [String]()
    
    open func addBlinds(_ blinds: [String]) {
        self.blindsPeers += blinds
    }

    open func addFinders(_ finders: [String]) {
        self.finderPeers += finders
    }

    open func foundPeersForTest() -> [MCPeerID] {
        return self.foundPeers
    }

    open func name() -> String {
        return self.peer.displayName
    }

    open func sendTestData(to peer: String) {
        for connectedPeer in self.session.connectedPeers {
            if peer == connectedPeer.displayName {
                let data = Data.init(bytes: [1,2,3,4])
                do {
                    _ = try session.send(data , toPeers: [connectedPeer], with: .reliable)
                } catch {
                    print(error)
                }
                break
            }
        }
    }

    func discoveryInfoForTest() -> [String: String]? {
        var info: [String: String]?
        if blindsPeers.count > 0 || finderPeers.count > 0 {
            info = [String: String]()
            if blindsPeers.count > 0 {
                info!["blinds"] = blindsStr()
            }
            if finderPeers.count > 0 {
                info!["finders"] = findersStr()
            }
        }

        return info
    }

    func blindsStr() -> String {
        var blinds = ""
        for (index, peer) in blindsPeers.enumerated() {
            blinds += peer
            if index != blindsPeers.count - 1 {
                blinds += ","
            }
        }
        return blinds
    }

    func findersStr() -> String {
        var finders = ""
        for (index, peer) in finderPeers.enumerated() {
            finders += peer
            if index != finderPeers.count - 1 {
                finders += ","
            }
        }
        return finders
    }

    //MARK: real node

    fileprivate var session: MCSession!

    fileprivate var peer: MCPeerID!

    fileprivate var browser: MCNearbyServiceBrowser?

    fileprivate var advertiser: MCNearbyServiceAdvertiser?

    fileprivate var foundPeers = [MCPeerID]()

    internal var invitationHandler: ((Bool) -> Void)!

    open var delegate: MultipeerTransportLayerDelegate?

    var isMaster: Bool = false

    init(_ name: String = UIDevice.current.name) {
        super.init()
        peer = MCPeerID(displayName: name)
        session = MCSession(peer: peer)
        session.delegate = self
    }

    func createBrowser(_ serviceType: String) {
        foundPeers = [MCPeerID]()
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        browser?.delegate = self
        startBrowser()
    }

    fileprivate func startBrowser() {
        browser?.startBrowsingForPeers()
    }

    fileprivate func stopBrowser() {
        browser?.stopBrowsingForPeers()
    }

    func createAdvertiser(_ serviceType: String) {
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: self.discoveryInfoForTest(), serviceType: serviceType)
        advertiser?.delegate = self
        startAdvertiser()
    }

    fileprivate func startAdvertiser() {
        advertiser?.startAdvertisingPeer()
    }

    fileprivate func stopAdvertiser() {
        advertiser?.stopAdvertisingPeer()
    }

    //MARK : - MCNearbyServiceBrowserDelegate
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //Normal
        //self.foundPeers.append(peerID)
        if session.connectedPeers.contains(peerID) {
            return
        }
        //For Test
        if info != nil {
            let peerBlinds = info!["blinds"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            let peerFinders = info!["finders"]?.components(separatedBy: CharacterSet.init(charactersIn: ","))
            if playGround.shouldFound(peerID: peerID.displayName, blinds: blindsPeers, finders: finderPeers) && playGround.shouldFound(peerID: self.peer.displayName, blinds:peerBlinds , finders: peerFinders) {
                self.foundPeers.append(peerID)
                playGround.foundPeer(node: self, peerID: peerID.displayName, withDiscoveryInfo: info)
            }
        } else {
            if playGround.shouldFound(peerID: peerID.displayName, blinds: blindsPeers, finders: finderPeers) {
                self.foundPeers.append(peerID)
                playGround.foundPeer(node: self, peerID: peerID.displayName, withDiscoveryInfo: info)
            }
        }


    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated() {
            if aPeer == peerID {
                foundPeers.remove(at: index)
                playGround.foundPeer(node: self, peerID: peerID.displayName, withDiscoveryInfo: nil)
                break
            }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }

    func invite(node: String, withContext: Data?, timeout: TimeInterval) {
        for peer in foundPeers {
            if node == peer.displayName {
                self.browser?.invitePeer(peer, to: session, withContext: withContext, timeout: timeout)
                break
            }
        }
    }

    //MARK : MCNearbyServiceAdvertiserDelegate
    internal func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Swift.Void) {
        self.invitationHandler = { (invitation: Bool) -> Swift.Void  in
            invitationHandler(invitation, self.session)
        }
        //for test
        self.invitationHandler(true)
    }

    internal func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }

    //MARK : MCSessionDelegate
    internal func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            for (index, aPeer) in foundPeers.enumerated() {
                if aPeer == peerID {
                    foundPeers.remove(at: index)
                    break
                }
            }
            playGround.connected(node: self, with: peerID.displayName)
            print("Connected to session: \(session)")

        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
        case MCSessionState.notConnected:
            print("Lost connection to session: \(session)")
        }
    }

    internal func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

    }

    internal func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }

    internal func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }

    internal func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }



    //MARK: str
    func foundPeersStr() -> String {
        var foundPeers = "FoundPeers: "
        for (index, peer) in self.foundPeers.enumerated() {
            foundPeers += peer.displayName
            if index != self.foundPeers.count - 1 {
                foundPeers += ", "
            }
        }

        return foundPeers
    }

    func connectedPeersStr() -> String {
        var connectedPeers = "Connected: "
        for (index, peer) in self.session.connectedPeers.enumerated() {
            connectedPeers += peer.displayName
            if index != self.session.connectedPeers.count - 1 {
                connectedPeers += ", "
            }
        }

        return connectedPeers
    }
}

