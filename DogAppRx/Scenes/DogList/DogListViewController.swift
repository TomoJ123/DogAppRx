import UIKit
import RxSwift
import RxCocoa

class DogListViewController: UIViewController {
    private let viewModel: DogListViewModelType
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "DogCellIdentifier"
    
    init(viewModel: DogListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    override func loadView() {
        view = DogListView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupUI() {
        guard let view = view as? DogListView else {
            fatalError("Wrong view class!")
        }
        
        self.title = "Dogs"
        
        view.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func bindViewModel() {
        guard let view = view as? DogListView else {
            fatalError("Wrong view class!")
        }
        
        let itemSelected = view.tableView
            .rx
            .itemSelected
            .map { $0.row }
            .asDriver(onErrorJustReturn: 0)
        
        let didAppear = rx.methodInvoked(#selector(UIViewController.viewDidAppear)).map { $0.first as? Bool ?? false}.asDriver(onErrorJustReturn: false)
        
        let input = DogListViewModelInput(itemSelected: itemSelected, viewDidAppear: didAppear)
        
        let output = viewModel.transform(input: input)
        
        output.dogList
            .asObservable()
            .bind(to: view.tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) {
                (index, item: DogListItem, cell) in
                cell.textLabel?.text = item.name
            }
            .disposed(by: disposeBag)
        
        output.itemSelected
            .drive()
            .disposed(by: disposeBag)
    }
}
