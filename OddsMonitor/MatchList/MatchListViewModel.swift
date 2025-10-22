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
    
    func getDetailViewModel(for index: Int) -> MatchDetailViewModel? {
        guard index >= 0 && index < matchPublisher.value.count else { return nil }
        let match = matchPublisher.value[index]
        return MatchDetailViewModel(match: match)
    }
    
    func subscribeOddsChanges() {
        WebSocketManager.shared.addDelegate(for: 0, self)
    }
    
    func unsubscribeOddsChanges() {
        WebSocketManager.shared.removeDelegate(for: 0)
    }
}

private extension MatchListViewModel {
    func prepareData(matchesResponse: [MatchResponse], oddsResponse: [OddsResponse]) -> [Match] {
        var oddsDictionary = [Int: OddsResponse]()
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

extension MatchListViewModel: WebSocketManagerDelegate {
    func didReceive(id: Int, updatedOdds: OddsResponse) {
        Task { [weak self] in
            guard let self else { return }
            await self.matchStore.updateOdds(updatedOdds)
            let matches = await self.matchStore.getMatches()
            self.matchPublisher.send(matches)
        }
    }
}
