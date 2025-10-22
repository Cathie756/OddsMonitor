//
//  MatchDetailCell.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/21.
//

import UIKit

class MatchDetailCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var oddsLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = "--"
        oddsLabel.text = "0.0"
    }
    
    func build(name: String, odds: Double) {
        nameLabel.text = name
        oddsLabel.text = String(format: "%.2f", odds)
    }
}
