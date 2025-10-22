//
//  MatchDetailViewController.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/21.
//

import UIKit

class MatchDetailViewController: UIViewController {
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var matchTimeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MatchDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupTableView()
    }
    
    func configureUI() {
        guard let match = viewModel?.match else { return }
        teamANameLabel.text = match.teamA
        teamBNameLabel.text = match.teamB
        matchTimeLabel.text = match.startTime.toReadableString()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "\(MatchDetailCell.self)", bundle: nil), forCellReuseIdentifier: "\(MatchDetailCell.self)")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MatchDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MatchDetailViewModel.RowType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let match = viewModel?.match,
              let cell = tableView.dequeueReusableCell(withIdentifier: "\(MatchDetailCell.self)", for: indexPath) as? MatchDetailCell else {
            return UITableViewCell()
        }
        guard let rowType = MatchDetailViewModel.RowType(rawValue: indexPath.row) else {
            return cell
        }
        
        switch rowType {
        case .teamA:
            cell.build(name: match.teamA, odds: match.teamAOdds)
        case .draw:
            cell.build(name: "Draw", odds: match.drawOdds)
        case .teamB:
            cell.build(name: match.teamB, odds: match.teamBOdds)
        }
        return cell
    }
}

extension MatchDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
