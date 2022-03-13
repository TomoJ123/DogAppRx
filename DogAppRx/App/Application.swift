import UIKit

class Application {
    static let shared = Application()
    
    func start(in window: UIWindow) {
        let navigationController = UINavigationController()
        
        let dogProvider = DogProvider(httpService: HTTPService())
        let dogNavigator = DogNavigator(navigationController: navigationController, dogProvider: dogProvider)
        dogNavigator.toDogList()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}


