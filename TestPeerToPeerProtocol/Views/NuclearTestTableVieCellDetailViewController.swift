//
//  NuclearTestTableVieCellDetailViewController.swift
//  TestPeerToPeerProtocol
//
//  Created by Teemo on 2018/7/7.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class NuclearTestTableVieCellDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var connectNodeTextField: UITextField!
    @IBOutlet weak var disConnectedNodeTextField: UITextField!
    @IBOutlet weak var foundPeersLabel: UILabel!
    @IBOutlet weak var connectedPeersLabel: UILabel!
    var node: NFCNetworkNodeProtocolForTest
    
    init(node: NFCNetworkNodeProtocolForTest) {
        self.node = node
        super.init(nibName: "NuclearTestTableVieCellDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadView()
        
    }
    
    func reloadView() {
        self.nameLabel.text = node.peerID
        self.foundPeersLabel.text = node.foundPeersStr()
        self.connectedPeersLabel.text = node.connectedPeersStr()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func connect(_ sender: Any) {
        if connectNodeTextField.text?.uppercased() != node.peerID && connectNodeTextField.text != "" {
            NuclearTest.labs.connectTo(name: self.connectNodeTextField.text!.uppercased(), from: node)
            self.connectNodeTextField.text = ""
            self.reloadView()
        }
    }
    
    @IBAction func disConnect(_ sender: Any) {
        if disConnectedNodeTextField.text != "" {
            NuclearTest.labs.disConnectWith(user: disConnectedNodeTextField.text!.uppercased(), node: node)
            self.disConnectedNodeTextField.text = ""
            self.reloadView()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
