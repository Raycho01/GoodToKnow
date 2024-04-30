//
//  HomeCarouselViewModel.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import Combine
import Foundation

protocol HomeServiceProtocol {
    typealias HomeDataCompletion = ([CarouselModel]) -> Void
    
    func fetchHomeCarouselData() -> AnyPublisher<[CarouselModel], Error>
}

final class HomeCarouselViewModel: CarouselViewModelProtocol, ObservableObject {
        
    @Published var carouselModels: [CarouselModel] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private let service: HomeServiceProtocol
    
    init(service: HomeServiceProtocol = HomeMockedService()) {
        self.service = service
        callService()
    }
    
    func bind() -> AnyPublisher<[CarouselModel], Never> {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        return $carouselModels.eraseToAnyPublisher()
    }
    
    private func callService() {
        service.fetchHomeCarouselData()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { [weak self] homeCarouselData in
                self?.carouselModels = homeCarouselData
            })
            .store(in: &cancellables)
    }
}

