//
//  MainInteractor.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import Combine

protocol MainRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func attachWatchlist()
    func attachOpinion()
    func attachNews()
    
    func attachSearch()
    func detachSearch()
    
    func attachWritingOpinion()
    func detachWritingOpinion()
    
    func attachCoinDetail()
    func detachCoinDetail()
}

protocol MainPresentable: Presentable {
    var listener: MainPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func openNews(of url: String)
}

protocol MainListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol MainInteractorDependency {
    var symbolSubject: PassthroughSubject<CoinCapAsset, Never> { get }
    var lifeCycleDidChangeSubject: PassthroughSubject<ViewControllerLifeCycle, Never> { get }
}

final class MainInteractor: PresentableInteractor<MainPresentable>, MainInteractable, MainPresentableListener, AdaptivePresentationControllerDelegate {
   
    weak var router: MainRouting?
    weak var listener: MainListener?
    
    private let dependency: MainInteractorDependency
    
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    init(
        presenter: MainPresentable,
        dependency: MainInteractorDependency
    ) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachWatchlist()
        router?.attachOpinion()
        router?.attachNews()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}

// MARK: - Life Cycle
extension MainInteractor {
    func viewWillAppear() {
        dependency.lifeCycleDidChangeSubject.send(.viewWillAppear)
    }

    func viewWillDisappear() {
        dependency.lifeCycleDidChangeSubject.send(.viewWillDisappear)
    }
}

// MARK: - News
extension MainInteractor {
    func openNews(of url: String) {
        presenter.openNews(of: url)
    }
}

// MARK: - Search
extension MainInteractor {
    func searchButtonDidTap() {
        router?.attachSearch()
    }
    
    func searchDidTapBackButton() {
        router?.detachSearch()
    }
}

// MARK: - Writing Opinion
extension MainInteractor {
    func writingOpinionButtonDidTap() {
        router?.attachWritingOpinion()
    }
    
    func writingOpinionDidTapDismiss() {
        router?.detachWritingOpinion()
    }
    
    func presentationControllerDidDismiss() {
        router?.detachWritingOpinion()
    }
}

// MARK: - CoinDetail
extension MainInteractor {
    func watchlistDidTap(_ symbol: CoinCapAsset) {
        router?.attachCoinDetail()
        dependency.symbolSubject.send(symbol)
    }
    
    func coinDetailDidTapBackButton() {
        router?.detachCoinDetail()
    }
}
