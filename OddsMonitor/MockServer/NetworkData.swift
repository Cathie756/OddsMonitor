//
//  NetworkData.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/19.
//

import Foundation

// GET /matches
struct MatchResponse {
    let matchID: Int
    let startTime: String
    let teamA: String
    let teamB: String
}

// GET /odds
struct OddResponse {
    let matchID: Int
    let teamAOdds: Double
    let teamBOdds: Double
    let drawOdds: Double
}
