//
//  HomeViewController.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 6/20/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NotificationForTest {

    @IBOutlet weak var nodesTableView: UITableView!
    @IBOutlet weak var nodeNameTextField: UITextField!
    @IBOutlet weak var nodeBlindsTextField: UITextField!
    @IBOutlet weak var nodeFindersTextField: UITextField!
    let labs = NuclearPlayground.labs
    var allNodes = NuclearPlayground.labs.allGNLNode

    override func loadView() {
        super.loadView()
        labs.oberservers.append(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nodesTableView.register(UINib.init(nibName: "NuclearTestNodeTableViewCell", bundle: nil), forCellReuseIdentifier: "NuclearTestNodeTableViewCell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadView()
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
            reloadView()
            nodeNameTextField.text = ""
        }
        self.view.endEditing(true)

    }
    
    //MARK: UITableView delegate and datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return allNodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NuclearTestNodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NuclearTestNodeTableViewCell") as! NuclearTestNodeTableViewCell
        let node: GrandNetworkLayerNode = allNodes[indexPath.row]
        cell.nameLabel.text = node.displayName
        cell.parentLabel.text = "Parent: nil"
        cell.foundPeersLabel.text = node.foundPeersStr()
        cell.childrenLabel.text = node.connectedPeersStr()

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node: GrandNetworkLayerNode = allNodes[indexPath.row]
        let details = NuclearTestTableVieCellDetailViewController.init(node: node)
        self.present(details, animated: true, completion: nil)
    }

    //MARK: NotificationForTest
    func foundPeer(node: MultipeerNetWorkNode, peerID: String, withDiscoveryInfo info: [String : String]?) {
        reloadView()
    }

    func connected(node: MultipeerNetWorkNode, with peer: String) {
        reloadView()
    }
    
    func reloadView() {
        allNodes = labs.allGNLNode
        DispatchQueue.main.async {
            self.nodesTableView.reloadData()
        }
    }

}

