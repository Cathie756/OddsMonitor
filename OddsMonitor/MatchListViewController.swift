//
//  MatchListViewController.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/17.
//

import UIKit
import Combine

class MatchListViewController: UIViewController {
    let viewModel = MatchListViewModel()

    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataBinding()
    }

    func dataBinding() {
        Task {
            await viewModel.fetchData()
        }
        viewModel.matchPublisher
            .receive(on: DispatchQueue.main)
            .sink { matches in
                matches.forEach({ print($0) })
            }
            .store(in: &cancellable)
    }

}

