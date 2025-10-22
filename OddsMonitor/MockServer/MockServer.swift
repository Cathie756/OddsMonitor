//
//  MockServer.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/18.
//

import Foundation

protocol MockServerDelegate: AnyObject {
    func didReceive(updatedOdds: OddsResponse)
}

class MockServer {
    static let shared = MockServer()

    private var timer: Timer?
    private weak var delegate: MockServerDelegate?
    
    func getMatches() async throws -> [MatchResponse] {
        let delayTime = UInt64.random(in: 100...300) * 1000 * 1000
        try await Task.sleep(nanoseconds: delayTime)
        let matches = generateOriginalMatchData()
        return matches
    }
    
    func getOdds() async throws -> [OddsResponse] {
        let delayTime = UInt64.random(in: 100...300) * 1000 * 1000
        try await Task.sleep(nanoseconds: delayTime)
        let odds = generateOriginalOddData()
        return odds
    }
    
    func subscribeWebsocket(delegate: MockServerDelegate) {
        self.delegate = delegate
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            let matchID = Int.random(in: 1001...1100)
            let newOdds = self.generateOddsMockData(matchID: matchID)
            NSLog("send update for \(matchID)")
            self.delegate?.didReceive(updatedOdds: newOdds)
        })
    }
    
    func unsubscribeWebsocket() {
        timer?.invalidate()
        timer = nil
        delegate = nil
    }
}

private extension MockServer {
    func generateOriginalMatchData() -> [MatchResponse] {
        let firstMatchID = 1001
        let firstTimeStamp = getNextHourFromNow()?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        var matches: [MatchResponse] = []
        for index in 0 ..< Const.dataCount {
            let matchID = firstMatchID + index
            let timeStamp = firstTimeStamp + 3600 * Double(index)
            let startTime = getFormattedDateString(from: timeStamp)
            
            let teams = countries.shuffled().prefix(2)
            let teamA = teams[0]
            let teamB = teams[1]
            let match = MatchResponse(matchID: matchID, startTime: startTime, teamA: teamA, teamB: teamB)
            matches.append(match)
        }
        return matches
    }
    
    func getNextHourFromNow() -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
        components.hour? += 1
        components.minute = 0
        components.second = 0
        return calendar.date(from: components)
    }
    
    func getFormattedDateString(from timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        return date.toIsoString()
    }
}

private extension MockServer {
    func generateOriginalOddData() -> [OddsResponse] {
        let firstMatchID = 1001
        var odds: [OddsResponse] = []
        for index in 0 ..< Const.dataCount {
            let matchID = firstMatchID + index
            let odd = generateOddsMockData(matchID: matchID)
            odds.append(odd)
        }
        return odds
    }
    
    func generateOddsMockData(matchID: Int) -> OddsResponse {
        let teamARate = Double.random(in: 0.2...0.6)
        let drawRate = Double.random(in: 0.2...0.3)
        let teamBRate = 1.0 - teamARate - drawRate
        let teamAOdds = round(1.0 / teamARate * 100) / 100
        let teamBOdds = round(1.0 / teamBRate * 100) / 100
        let drawOdds = round(1.0 / drawRate * 100) / 100
        return OddsResponse(matchID: matchID, teamAOdds: teamAOdds, teamBOdds: teamBOdds, drawOdds: drawOdds)
    }
}

private extension MockServer {
    struct Const {
        static let dataCount: Int = 100
    }
}
