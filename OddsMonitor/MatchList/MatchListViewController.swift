//
//  MatchListViewController.swift
//  OddsMonitor
//
//  Created by Chia-Yun Lee on 2025/10/17.
//

import UIKit
import Combine

typealias MatchListDataSource = UITableViewDiffableDataSource<Int, Match>
typealias MatchListSnapShot = NSDiffableDataSourceSnapshot<Int, Match>

class MatchListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = MatchListViewModel()
    private var dataSource: MatchListDataSource?
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        dataBinding()
    }
    
    deinit {
        viewModel.unsubscribeOddsChanges()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "\(MatchCell.self)", bundle: nil), forCellReuseIdentifier: "\(MatchCell.self)")
        configureDataSource()
        tableView.delegate = self
    }
    
    func dataBinding() {
        Task {
            await viewModel.fetchData()
        }
        viewModel.matchPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matches in
                self?.applySnapshot(matches: matches)
            }
            .store(in: &cancellable)
        viewModel.subscribeOddsChanges()
    }
}

// diffable data source
private extension MatchListViewController {
    func configureDataSource() {
        let provider: MatchListDataSource.CellProvider = { tableView, indexPath, match -> UITableViewCell? in
            NSLog("loading row \(indexPath.row) for matchID: \(match.matchID)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(MatchCell.self)", for: indexPath) as? MatchCell else {
                return UITableViewCell()
            }
            cell.build(model: match)
            return cell
        }
        dataSource = MatchListDataSource(tableView: tableView, cellProvider: provider)
        tableView.dataSource = dataSource
    }
    
    func applySnapshot(matches: [Match]) {
        var snapshot = MatchListSnapShot()
        snapshot.appendSections([0])
        snapshot.appendItems(matches)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension MatchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewModel = viewModel.getDetailViewModel(for: indexPath.row)
        let controller = MatchDetailViewController()
        controller.viewModel = detailViewModel
        navigationController?.pushViewController(controller, animated: true)
    }
}
