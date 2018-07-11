//
//  NuclearTestTableVieCellDetailViewController.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/7/7.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class NuclearTestTableVieCellDetailViewController: UIViewController, NotificationForTest {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectNodeTextField: UITextField!
    @IBOutlet weak var disConnectedNodeTextField: UITextField!
    @IBOutlet weak var sendDataNodeTextField: UITextField!
    @IBOutlet weak var foundPeersLabel: UILabel!
    @IBOutlet weak var connectedPeersLabel: UILabel!
    var GNL: GrandNetworkLayerNode
    
    init(node: GrandNetworkLayerNode) {
        self.GNL = node
        super.init(nibName: "NuclearTestTableVieCellDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        NuclearPlayground.labs.oberservers.append(self)
        super.viewDidLoad()
        self.reloadView()
    }
    
    func reloadView() {
        DispatchQueue.main.async {
            self.nameLabel.text = self.GNL.node.name()
            self.foundPeersLabel.text = self.GNL.node.foundPeersStr()
            self.connectedPeersLabel.text = self.GNL.node.connectedPeersStr()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func connect(_ sender: Any) {
        if connectNodeTextField.text?.uppercased() != GNL.node.name() && connectNodeTextField.text != "" {
            GNL.node.invite(node: connectNodeTextField.text!.uppercased(), withContext: nil, timeout: 1000)
            self.connectNodeTextField.text = ""
            self.reloadView()
        }
    }
    
    @IBAction func disConnect(_ sender: Any) {
        if disConnectedNodeTextField.text != "" {
            self.disConnectedNodeTextField.text = ""
            self.reloadView()
        }
    }

    @IBAction func sendData(_ sender: Any) {
        if sendDataNodeTextField.text != "" {
            GNL.node.sendTestData(to: sendDataNodeTextField.text!.uppercased())
        }
    }

    //MARK: NotificationForTest
    func foundPeer(node: MultipeerNetWorkNode, peerID: String, withDiscoveryInfo info: [String : String]?) {
        reloadView()
    }

    func connected(node: MultipeerNetWorkNode, with peer: String) {
        reloadView()
    }

}
