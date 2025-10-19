//
//  MatchCell.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/19.
//

import UIKit

class MatchCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamANameLabel: UILabel!
    @IBOutlet weak var teamBNameLabel: UILabel!
    @IBOutlet weak var teamAOddLabel: UILabel!
    @IBOutlet weak var teamBOddLabel: UILabel!
    @IBOutlet weak var drawOddLabel: UILabel!

    override func prepareForReuse() {
        timeLabel.text = nil
        teamANameLabel.text = nil
        teamBNameLabel.text = nil
        teamAOddLabel.text = nil
        teamBOddLabel.text = nil
        drawOddLabel.text = nil
    }

    func build(model: Match) {
        timeLabel.text = model.startTime.toReadableString()
        teamANameLabel.text = model.teamA
        teamBNameLabel.text = model.teamB
        teamAOddLabel.text = String(format: "%.2f", model.teamAOdds)
        teamBOddLabel.text = String(format: "%.2f", model.teamBOdds)
        drawOddLabel.text = String(format: "%.2f", model.drawOdds)
    }
}
