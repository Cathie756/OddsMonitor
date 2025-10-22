//
//  MatchDetailViewModel.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/21.
//

import Foundation
import Combine

class MatchDetailViewModel {
    var match: CurrentValueSubject<Match, Never>

    init(match: Match) {
        self.match = CurrentValueSubject<Match, Never>(match)
    }
    
    func subscribeOddsChanges() {
        WebSocketManager.shared.addDelegate(for: match.value.matchID, self)
    }
    
    func unsubscribeOddsChanges() {
        WebSocketManager.shared.removeDelegate(for: match.value.matchID)
    }
}

extension MatchDetailViewModel: WebSocketManagerDelegate {
    func didReceive(id: Int, updatedOdds: OddsResponse) {
        guard match.value.matchID == id else { return }
        var updatedMatch = match.value
        updatedMatch.teamAOdds = updatedOdds.teamAOdds
        updatedMatch.teamBOdds = updatedOdds.teamBOdds
        updatedMatch.drawOdds = updatedOdds.drawOdds
        match.send(updatedMatch)
    }
}

extension MatchDetailViewModel {
    enum RowType: Int, CaseIterable {
        case teamA = 0
        case draw
        case teamB
    }
}
