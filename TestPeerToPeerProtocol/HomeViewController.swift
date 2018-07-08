//
//  HomeViewController.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nodesTableView: UITableView!
    @IBOutlet weak var nodeNameTextField: UITextField!
    @IBOutlet weak var nodeBlindsTextField: UITextField!
    @IBOutlet weak var nodeFindersTextField: UITextField!
    let labs = NuclearTest.labs
    var allNodes = NuclearTest.labs.networkNodes[NuclearTest.testNetwork]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nodesTableView.register(UINib.init(nibName: "NuclearTestNodeTableViewCell", bundle: nil), forCellReuseIdentifier: "NuclearTestNodeTableViewCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func createNode(_ sender: Any) {
        let name = nodeNameTextField.text!.uppercased().trimmingCharacters(in: NSCharacterSet.whitespaces)
        if name == "" {
            return
        }
        var blinds = [String]()
        var finders = [String]()
        if nodeBlindsTextField.text != "" {
            blinds += nodeBlindsTextField.text!.uppercased().components(separatedBy: CharacterSet.init(charactersIn: ","))
        }
        if nodeFindersTextField.text != "" {
            finders += nodeFindersTextField.text!.uppercased().components(separatedBy: CharacterSet.init(charactersIn: ","))
        }
        if labs.addNode(name: name, blinds: blinds, finders: finders) {
            reloadData()
            nodeNameTextField.text = ""
        }

    }
    
    func reloadData() {
        allNodes = labs.networkNodes[NuclearTest.testNetwork]
        self.nodesTableView.reloadData()
    }
    
    //MARK: UITableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allNodes == nil {
            return 0
        } else {
            return allNodes!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NuclearTestNodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NuclearTestNodeTableViewCell") as! NuclearTestNodeTableViewCell
        let node: NFCNetworkNodeProtocolForTest = allNodes![indexPath.row]
        cell.nameLabel.text = node.peerID
        cell.parentLabel.text = "Parent: nil"
        cell.foundPeersLabel.text = node.foundPeersStr()
        cell.childrenLabel.text = node.connectedPeersStr()

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node: NFCNetworkNodeProtocolForTest = allNodes![indexPath.row]
        let details = NuclearTestTableVieCellDetailViewController.init(node: node)
        self.present(details, animated: true, completion: nil)
    }
}

