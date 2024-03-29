//
//  SearchInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import UIKit.UITableView
import ModernRIBs
import Combine

protocol SearchRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachCoinDetail()
    func detachCoinDetail()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func reloadData(with data: [CoinCapAsset], animation: UITableView.RowAnimation)
}

protocol SearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func searchDidTapBackButton()
}

protocol SearchInteractorDependency {
    var searchRepository: SearchRepository { get }
    var symbolSubject: PassthroughSubject<CoinCapAsset, Never> { get }
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    
    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    private let dependency: SearchInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    private var filteredItems: [CoinCapAsset] = []
    private var originalItems: [CoinCapAsset] = []
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(
        presenter: SearchPresentable,
        dependency: SearchInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
        
        fetchSymbols()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapBackButton() {
        listener?.searchDidTapBackButton()
    }
    
    func search(text: String) {
        filteredItems = text.isEmpty ? originalItems : originalItems.filter({
            $0.name.lowercased().contains(text.lowercased()) ||
            $0.symbol.lowercased().contains(text.lowercased())
        })
        presenter.reloadData(
            with: filteredItems,
            animation: .middle
        )
    }
    
    func didTap(_ indexPath: IndexPath) {
        router?.attachCoinDetail()
        dependency.symbolSubject.send(filteredItems[indexPath.row])
    }
    
    func coinDetailDidTapBackButton() {
        router?.detachCoinDetail()
    }
    
    private func fetchSymbols() {
        dependency
            .searchRepository
            .fetchSymbols()
            .receive(on: DispatchQueue.main)
            .sink {[weak self] completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    self?.reloadData()
                }
            } receiveValue: {[weak self] response in
                self?.originalItems = response.data
                self?.filteredItems = response.data
            }
            .store(in: &cancellables)
    }
    
    private func reloadData() {
        presenter.reloadData(
            with: filteredItems,
            animation: .left
        )
    }
}
