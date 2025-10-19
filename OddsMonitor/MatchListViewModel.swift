//
//  MatchListViewModel.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/18.
//

import Foundation
import Combine

class MatchListViewModel {
    let matchStore = MatchStore()
    let matchPublisher = CurrentValueSubject<[Match], Never>([])
    
    func fetchData() async {
        async let matchesResponse = MockServer.shared.getMatches()
        async let oddsResponse = MockServer.shared.getOdds()
        do {
            let (matchesResp, oddsResp) = try await (matchesResponse, oddsResponse)
            let matches = prepareData(matchesResponse: matchesResp, oddsResponse: oddsResp)
            await matchStore.addMatches(matches)
            matchPublisher.send(matches)
        } catch {
            NSLog("MatchListViewModel fetchData catch error: \(error.localizedDescription)")
        }
    }
}

private extension MatchListViewModel {
    func prepareData(matchesResponse: [MatchResponse], oddsResponse: [OddResponse]) -> [Match] {
        var oddsDictionary = [Int: OddResponse]()
        oddsResponse.forEach({ oddsDictionary[$0.matchID] = $0 })
        var matches: [Match] = []
        matchesResponse.forEach({ matchResponse in
            guard let oddResponse = oddsDictionary[matchResponse.matchID] else { return }
            let match = Match(matchResponse: matchResponse, oddResponse: oddResponse)
            matches.append(match)
        })
        matches.sort { $0.startTime < $1.startTime }
        return matches
    }
}
