//
//  SearchRepository.swift
//  iCoin
//
//  Created by 김윤석 on 2022/06/12.
//

import Combine

protocol SearchRepository {
    func fetchSymbols() -> AnyPublisher<[SearchResult], Error>
}

final class SearchRepositoryImp: SearchRepository {
    
    private let network: SearchNetwork
    
    init(network: SearchNetwork) {
        self.network = network
        
    }
    
    func fetchSymbols() -> AnyPublisher<[SearchResult], Error> {
        return network.fetchSymbols()
    }
}

