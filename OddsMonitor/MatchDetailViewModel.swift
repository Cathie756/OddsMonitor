//
//  MatchDetailViewModel.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/21.
//

import Foundation

class MatchDetailViewModel {
    var match: Match

    init(match: Match) {
        self.match = match
    }
}

extension MatchDetailViewModel {
    enum RowType: Int, CaseIterable {
        case teamA = 0
        case draw
        case teamB
    }
}
