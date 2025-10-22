//
//  WebSocketManager.swift
//  OddsMonitor
//
//  Created by Cathie Lee on 2025/10/22.
//

import UIKit

protocol WebSocketManagerDelegate {
    func didReceive(id: Int, updatedOdds: OddsResponse)
}

class WebSocketManager {
    static let shared = WebSocketManager()
    
    private var delegates = [Int: WebSocketManagerDelegate]()
    
    init() {
        connect()
        addAppLifeCycleObserver()
    }
    
    deinit {
        disconnect()
    }
    
    /// set id: 0 to subscribe all events
    func addDelegate(for id: Int, _ delegate: WebSocketManagerDelegate) {
        delegates[id] = delegate
    }
    
    func removeDelegate(for id: Int) {
        delegates[id] = nil
   }
}

extension WebSocketManager: MockServerDelegate {
    func didReceive(updatedOdds: OddsResponse) {
        let matchID = updatedOdds.matchID
        if let allEventDelegate = delegates[Const.allEventKey] {
            allEventDelegate.didReceive(id: matchID, updatedOdds: updatedOdds)
        }
        if let delegate = delegates[matchID] {
            delegate.didReceive(id: matchID, updatedOdds: updatedOdds)
        }
    }
}

private extension WebSocketManager {
    struct Const {
        static let allEventKey: Int = 0
    }
    
    func addAppLifeCycleObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(connect),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(disconnect),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc
    func connect() {
        MockServer.shared.subscribeWebsocket(delegate: self)
    }
    
    @objc
    func disconnect() {
        MockServer.shared.unsubscribeWebsocket()
    }
}
