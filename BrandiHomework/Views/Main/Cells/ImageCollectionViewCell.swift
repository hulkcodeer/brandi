//
//  ImageCollectionViewCell.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import ReactorKit
import SDWebImage

internal final class ImageCollectionViewCell: CommonBaseCollectionViewCell, ReactorKit.View {
    
    // MARK: UI
    
    private lazy var imgView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: VARIABLE
    
    internal var disposeBag = DisposeBag()
    
    // MARK: FUNC
    
    func bind(reactor: MainListItemReactor) {
        reactor.state.compactMap { $0.model }
        .asDriver(onErrorJustReturn: nil)
        .drive(onNext: { [weak self] model in
            guard let self = self, let _model = model, let _url = URL(string: _model.imageUrl) else { return }
            self.imgView.sd_setImage(with: _url, completed: { [weak self] image, error, _, _ in
                guard let self = self else { return }
                if error != nil {
                    printLog(out: "Image Setting Fail")
                    self.imgView.image = nil
                }
            })                        
        })
        .disposed(by: self.disposeBag)
    }
    
    override func makeUI() {
        super.makeUI()
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            let width = floor(UIScreen.main.bounds.width / 3)
            $0.width.height.equalTo(width)
        }
    }
    
}
