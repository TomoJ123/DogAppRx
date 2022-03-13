import UIKit
import Nuke
import RxSwift
import RxCocoa

class DogDetailsViewController: UIViewController {
    private let viewModel: DogDetailsViewModelType
    private let bag = DisposeBag()
    
    init(title: String, viewModel: DogDetailsViewModelType) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func loadView() {
        view = DogDetailsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let view = view as? DogDetailsView else {
            fatalError("Wrong view class!")
        }
        let output = viewModel.transform()
        
        output.imagesUrl
            .asObservable()
            .bind(to: Binder(self, binding: { target, imagesUrl in
                Nuke.loadImage(with: imagesUrl.first, into: view.imageView)
            }))
            .disposed(by: bag)
    }
}

