//
//  HomeMockedService.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 20.03.24.
//

import Combine

enum FetchError: Error {
    case noMockedDataAvailable
}

final class HomeMockedService: HomeServiceProtocol {
    private let resourseName = "mockedCountries"
    
    func fetchHomeCarouselData() -> AnyPublisher<[HomeCarouselModel], Error> {
        guard let mockedCountries = BundleManager.shared.getResource(resourceName: resourseName, resultType: [HomeCarouselModel].self) else {
            return Fail(error: FetchError.noMockedDataAvailable)
                .eraseToAnyPublisher()
        }
        
        return Just(mockedCountries)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
