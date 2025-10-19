//
//  DataModel.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/18.
//

import Foundation

actor MatchStore {
    private var matches: [Match] = []

    func addMatches(_ matches: [Match]) {
        self.matches = matches
    }

    func updateOdds(_ newOdds: OddResponse) {
        guard let index = matches.firstIndex(where: { $0.matchID == newOdds.matchID }) else { return }
        var match = matches[index]
        match.teamAOdds = newOdds.teamAOdds
        match.teamBOdds = newOdds.teamBOdds
        match.drawOdds = newOdds.drawOdds
        matches[index] = match
    }

    func getMatches() -> [Match] {
        return matches
    }
}

struct Match: Hashable {
    let matchID: Int
    let startTime: Date
    let teamA: String
    let teamB: String
    var teamAOdds: Double
    var teamBOdds: Double
    var drawOdds: Double
    
    init(matchResponse: MatchResponse, oddResponse: OddResponse) {
        matchID = matchResponse.matchID
        teamA = matchResponse.teamA
        teamB = matchResponse.teamB
        teamAOdds = oddResponse.teamAOdds
        teamBOdds = oddResponse.teamBOdds
        drawOdds = oddResponse.drawOdds
        startTime = DateUtils.isoStringToDate(matchResponse.startTime) ?? Date()
    }
}
