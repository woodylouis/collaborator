//
//  PeerToPeerManager.swift
//  Collaborator
//
//  Created by WENJIN LI on 22/5/18.
//  Copyright © 2018 Wenjin Li. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol PeerToPeerManagerDelegate: AnyObject {
    func manager(_ manager: PeerToPeerManager, didReceive data: Data)
}

class PeerToPeerManager: NSObject {
    static let serviceType = "Collaboration-chitchat"
    var delegate: PeerToPeerManagerDelegate?
    private let peerID = MCPeerID(displayName: "Wenjin Li")
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    override init() {
        let service = PeerToPeerManager.serviceType
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: [peerID.displayName : UIDevice.current.name], serviceType: service)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: service)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
    // session to be established whenever is needed
    lazy var session: MCSession = {
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 10) {
        print("inviting \(peer.displayName)")
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
    }
}

extension PeerToPeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("did recieve invitation from \(peerID)")
        invitationHandler(true, session)
    }
    
    
}

extension PeerToPeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("did recieve \(data.count) bytes")
        delegate?.manager(self, didReceive: data)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("sessionDidChange \(state)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didRecievedStream \(streamName)")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didRecievedResource \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("finishRecievedResource \(resourceName)")
    }
}

extension PeerToPeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("found \(peerID.displayName)")
        invite(peer: peerID)
        
        func send(data: Data) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Error \(error) sending \(data.count) bytes of data")
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost \(peerID.displayName)")
    }
    
    
    
}

