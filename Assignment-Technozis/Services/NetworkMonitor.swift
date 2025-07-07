//
//  NetworkMonitor.swift
//  Assignment-Technozis
//
//  Created by abh on 06/07/25.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    var isConnected: Bool = true
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue(label: "Monitor"))
    }
}
