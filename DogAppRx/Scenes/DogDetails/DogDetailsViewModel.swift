import RxSwift
import RxCocoa
import UIKit.UIImageView

struct DogDetailsViewModelOutput {
    let imagesUrl: Driver<[String]>
}

protocol DogDetailsViewModelType {
    func transform() -> DogDetailsViewModelOutput
}

class DogDetailsViewModel: DogDetailsViewModelType {
    
    private let provider: DogProviderType
    private let dogName: String
    
    init(name: String, provider: DogProviderType) {
        self.dogName = name
        self.provider = provider
    }
    
    func transform() -> DogDetailsViewModelOutput {
        let response = provider.getDogDetails(name: dogName.decapitalizingFirstLetter())
            .flatMap { result -> Single<DogDetails> in
                switch result {
                case .success(let response):
                    return .just(response.toDogDetails())
                case .failure:
                    return .never()
                }
            }
            .map { $0.images }
            .asDriver(onErrorJustReturn: [])
        
        return DogDetailsViewModelOutput(imagesUrl: response)
    }
}
