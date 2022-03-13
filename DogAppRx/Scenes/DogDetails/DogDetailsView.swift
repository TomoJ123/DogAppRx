import UIKit
import SnapKit

class DogDetailsView: UIView {
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.alignment = .center
        sv.axis = .vertical
        sv.spacing = 15
        return sv
    }()
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
    let nameLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented!")
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(nameLabel)
    }
}
