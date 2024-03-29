//
//  WatchlistViewController.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import Combine
import UIKit

protocol WatchlistPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    func didTap(_ index: Int)
    func updateSections(completion: ([WatchlistItemModel]) -> Void)
    func removeItem(at indexPath: IndexPath)
    func turnOffSocket()
    func turnOnSocket()
}

enum Section: CaseIterable {
    case main
}

final class WatchlistViewController: UIViewController, WatchlistPresentable, WatchlistViewControllable {
   
    private typealias DataSource = TableViewDiffableDataSource
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, WatchlistItemModel>
    
    weak var listener: WatchlistPresentableListener?
    
    private var dataSource: DataSource?
    
    private let contentView = WatchlistView()
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = contentView
        
        configureTableViewDataSource()
    }
    
    func setTableEdittingMode() {
        contentView.tableView.setEditing(
            !contentView.tableView.isEditing,
            animated: true
        )
        if contentView.tableView.isEditing {
            listener?.turnOffSocket()
        } else {
            listener?.turnOnSocket()
        }
    }
    
    func reloadData(
        with data: [WatchlistItemModel],
        animation: UITableView.RowAnimation
    ) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
        dataSource?.defaultRowAnimation = animation
    }
}

// MARK: - UITableViewDataSource
extension WatchlistViewController {
    private func configureTableViewDataSource() {
        contentView.tableView.delegate = self
        dataSource = .init(
            tableView: contentView.tableView,
            cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
                guard
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: WatchlistItemCell.identifier,
                        for: indexPath
                    ) as? WatchlistItemCell
                else { return nil }
                cell.configure(with: item)
                return cell
            })
    }
}

// MARK: - UITableViewDelegate
extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listener?.didTap(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        WatchlistItemCell.preferredHeight
    }
}
