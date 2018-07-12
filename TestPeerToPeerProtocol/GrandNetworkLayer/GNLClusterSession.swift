//
//  GNLClusterSession.swift
//  TestPeerToPeerProtocol
//
//  Created by doxie on 7/12/18.
//  Copyright © 2018 Xie. All rights reserved.
//

import UIKit

class GNLClusterSession: MultipeerNetWorkNode {
    init(_ name: String, serviceType: String) {
        super.init(name + "-c")
        createAdvertiser(serviceType)
    }

}
