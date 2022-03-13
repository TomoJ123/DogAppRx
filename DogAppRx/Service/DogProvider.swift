import Foundation
import RxSwift
import RxCocoa

typealias DogListResult = Result<DogListResponse, Error>
typealias DogDetailsResult = Result<DogDetailsResponse, Error>

protocol DogProviderType {
    func getDogList() -> Single<DogListResult>
    func getDogDetails(name: String) -> Single<DogDetailsResult>
}

class DogProvider: DogProviderType {
    private struct Constants {
        static let baseUrl = "https://dog.ceo/api/breed"
        static let dogListPath = "s/list/all"
        static let dogDetailPath = "images/random/5"
    }
    
    private let httpService: HTTPServiceType
    
    init(httpService: HTTPServiceType) {
        self.httpService = httpService
    }
    
    func getDogList() -> Single<DogListResult> {
        let url = Constants.baseUrl + Constants.dogListPath
        
        return httpService.get(url: url, responseType: DogListResponse.self)
    }

    func getDogDetails(name: String) -> Single<DogDetailsResult> {
        let url = Constants.baseUrl + "/" + name + "/" + Constants.dogDetailPath
        
        return httpService.get(url: url, responseType: DogDetailsResponse.self)
    }
    
    
}
