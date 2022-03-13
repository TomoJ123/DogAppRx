import UIKit

protocol DogNavigatorType {
    func toDogList()
    func toDogDetails(name: String)
}

class DogNavigator: DogNavigatorType {
    private let navigationController: UINavigationController
    private let dogProvider: DogProviderType
    
    init(navigationController: UINavigationController, dogProvider: DogProviderType) {
        self.navigationController = navigationController
        self.dogProvider = dogProvider
    }
    
    func toDogList() {
        let viewModel = DogListViewModel(provider: dogProvider, navigator: self)
        let viewController = DogListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func toDogDetails(name: String) {
        let viewModel = DogDetailsViewModel(name: name, provider: dogProvider)
        let viewController = DogDetailsViewController(title: name, viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
