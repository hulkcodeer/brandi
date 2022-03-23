//
//  ImageDetailViewController.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/23.
//

import ReactorKit

internal final class ImageDetailViewController: CommonBaseViewController, StoryboardView {
    // MARK: UI
    
    private lazy var totalScrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    private lazy var imgView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var timeLbl = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textAlignment = .center
    }
    
    // MARK: VARIABLE
    
    internal var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: SYSTEM FUNC
    
    init(reactor: ImageDetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        let screenWidth = UIScreen.main.bounds.width
        view.backgroundColor = .white
        contentView.backgroundColor = .white
        contentView.addSubview(totalScrollView)
        totalScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        totalScrollView.addSubview(imgView)
        imgView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.width.equalTo(screenWidth)
        }
        
        totalScrollView.addSubview(timeLbl)
        timeLbl.snp.makeConstraints {
            $0.top.equalTo(imgView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }

    // MARK: BINDING
    
    func bind(reactor: ImageDetailViewReactor) {
        reactor.state.compactMap { $0.itemInfo }
            .observeOn(MainScheduler.instance)
            .bind { [weak self] itemInfo in
                guard let self = self else { return }
                switch itemInfo {
                case .image(let reactor):
                    guard let url = URL(string: reactor.initialState.model.imageUrl) else { return }
                    
                    self.timeLbl.text = "\(reactor.initialState.model.displaySiteName) \(reactor.initialState.model.dateTime)" 
                    
                    self.imgView.sd_setImage(with: url) { image, error, _, _ in
                        if error != nil {
                            printLog(out: "Image Setting Fail")
                            self.imgView.image = nil
                        }
                    }
                }
            }
            .disposed(by: self.disposeBag)
    }
}
