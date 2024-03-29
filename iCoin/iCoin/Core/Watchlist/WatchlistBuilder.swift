//
//  WatchlistBuilder.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/05.
//

import ModernRIBs
import Combine

protocol WatchlistDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var watchlistRepository: WatchlistRepository { get }
    var lifeCycleDidChangePublisher: AnyPublisher<ViewControllerLifeCycle, Never> { get }
}

final class WatchlistComponent: Component<WatchlistDependency>, WatchlistInteractorDependency {
    var watchlistRepository: WatchlistRepository { dependency.watchlistRepository }
    var lifeCycleDidChangePublisher: AnyPublisher<ViewControllerLifeCycle, Never> { dependency.lifeCycleDidChangePublisher }
    
    override init(
        dependency: WatchlistDependency
    ) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol WatchlistBuildable: Buildable {
    func build(withListener listener: WatchlistListener) -> WatchlistRouting
}

final class WatchlistBuilder: Builder<WatchlistDependency>, WatchlistBuildable {

    override init(dependency: WatchlistDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: WatchlistListener) -> WatchlistRouting {
        let component = WatchlistComponent(dependency: dependency)
        let viewController = WatchlistViewController()
        let interactor = WatchlistInteractor(
            presenter: viewController,
            dependency: component
        )
        interactor.listener = listener
        return WatchlistRouter(
            interactor: interactor,
            viewController: viewController
        )
    }
}
