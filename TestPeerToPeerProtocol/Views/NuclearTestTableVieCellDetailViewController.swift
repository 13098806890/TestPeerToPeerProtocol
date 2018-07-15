//
//  NuclearTestTableVieCellDetailViewController.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/7/7.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class NuclearTestTableVieCellDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotificationForTest, NuclearTestFoundPeerTableViewCellDelegate {



    @IBOutlet weak var foundPeersTableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectedUsersTableView: UITableView!

    var node: GrandNetworkLayerNode
    
    init(node: GrandNetworkLayerNode) {
        self.node = node
        super.init(nibName: "NuclearTestTableVieCellDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        NuclearPlayground.labs.oberservers.append(self)
        foundPeersTableView.register(UINib.init(nibName: "NuclearTestFoundPeerTableViewCell", bundle: nil), forCellReuseIdentifier: "NuclearTestFoundPeerTableViewCell")
        super.viewDidLoad()
        self.reloadView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    //MARK: tableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == foundPeersTableView {
            return node.foundPeers.count
        } else {
            return node.connectedUsers().count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == foundPeersTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NuclearTestFoundPeerTableViewCell") as! NuclearTestFoundPeerTableViewCell
            let foundPeer = node.foundPeers.sorted()[indexPath.row]
            cell.closeConnectButton.isHidden = !node.ableToBuildClusterConnection(foundPeer)
            cell.nameLabel.text = foundPeer
            cell.delegate = self

            return cell
        } else {
            let cell = UITableViewCell.init()
            cell.textLabel?.text = node.connectedUsers().sorted()[indexPath.row]
            
            return cell
        }
    }

    //MARK: NuclearTestFoundPeerTableViewCellDelegate

    func closeConnectTo(_ name: String) {
        self.node.inviteToCluster(name: name)
    }

    func connectTo(_ name: String) {

    }

    //MARK: NotificationForTest
    func foundPeer(node: MultipeerNetWorkNode, peerID: String, withDiscoveryInfo info: [String : String]?) {
        reloadView()
    }

    func connected(node: MultipeerNetWorkNode, with peer: String) {
        reloadView()
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.foundPeersTableView.reloadData()
            self.connectedUsersTableView.reloadData()
        }
    }

}
