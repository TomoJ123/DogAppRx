import RxSwift
import RxCocoa

struct DogListViewModelInput {
    let itemSelected: Driver<Int>
    let viewDidAppear: Driver<Bool>
}

struct DogListViewModelOutput {
    let dogList: Driver<[DogListItem]>
    let itemSelected: Driver<Void>
}

protocol DogListViewModelType {
    func transform(input: DogListViewModelInput) -> DogListViewModelOutput
}

class DogListViewModel: DogListViewModelType {
    private var items = [DogListItem]()
    
    private var provider: DogProviderType
    private var navigator: DogNavigatorType
    
    init(provider: DogProviderType, navigator: DogNavigatorType) {
        self.provider = provider
        self.navigator = navigator
    }
    
    func transform(input: DogListViewModelInput) -> DogListViewModelOutput {
        let didAppear = input.viewDidAppear
            .asObservable()
            .filter { _ in self.items.isEmpty }
            .flatMapLatest { _ in
                self.provider.getDogList()
            }
            .do(onNext: { result in
                if case let .success(response) = result {
                    let newItems = response.dogInfo.map { DogListItem(name: $0.key.capitalizingFirstLetter(), subBreed: $0.value) }
                    self.items.append(contentsOf: newItems)
                }
            })
            .map { _ in self.items }
            .asDriver(onErrorJustReturn: [])
        
        let itemSelected = input.itemSelected
            .asObservable()
            .do(onNext: { index in
                if index < self.items.count {
                    let dog = self.items[index]
                    self.navigator.toDogDetails(name: dog.name)
                }
            })
            .map { _ in ()}
            .asDriver(onErrorJustReturn: ())
        
        return DogListViewModelOutput(dogList: didAppear, itemSelected: itemSelected)
    }
}
