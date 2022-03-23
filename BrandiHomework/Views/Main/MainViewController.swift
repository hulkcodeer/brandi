//
//  ViewController.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import UIKit
import RxSwift
import RxCocoa
import ReusableKit
import ReactorKit
import RxDataSources

internal final class MainViewController: CommonBaseViewController, StoryboardView {
    typealias MainDataSource = RxCollectionViewSectionedReloadDataSource<MainListSection>
    
    private enum Reusable {
        static let imageCollectionViewCell = ReusableCell<ImageCollectionViewCell>(nibName: ImageCollectionViewCell.reuseID)
    }
    
    // MARK: UI
    
    private lazy var searchTotalView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var searchBar = UISearchBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "검색어를 입력해 주세요"
        $0.barTintColor = .white
        $0.searchBarStyle = .minimal
        $0.delegate = self
    }
    
    private let layout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)
        $0.sectionInsetReference = .fromSafeArea
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.sectionInset = .zero
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(Reusable.imageCollectionViewCell)
        $0.contentInsetAdjustmentBehavior = .automatic
        $0.contentInset = .zero
        $0.backgroundColor = .white
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    // MARK: VARIABLE
    
    internal var disposeBag = DisposeBag()
    
    private var timer: Timer?
    private lazy var dataSource = MainDataSource(configureCell: { dataSource, collectionView, indexPath, item in
        switch item {
        case .image(let reactor):
            let cell = collectionView.dequeue(Reusable.imageCollectionViewCell, for: indexPath)
            cell.reactor = reactor
            return cell
                              
        }
    })
        
    // MARK: SYSTEM FUNC
    
    override func loadView() {
        super.loadView()
        
        self.contentView.addSubview(searchTotalView)
        searchTotalView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        searchTotalView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchTotalView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: FUNC
    
    func bind(reactor: MainViewReactor) {        
        reactor.state.map { $0.sections }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .do(afterNext: { _ in
                reactor.isLoadingNextPage = false
            })

            .drive(collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
                        
        reactor.state.map { $0.selectedItemInfo }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] itemInfo in
                guard let self = self, let _itemInfo = itemInfo else { return }
                let reactor = ImageDetailViewReactor(item: _itemInfo)
                let viewcon = ImageDetailViewController(reactor: reactor)
                self.navigationController?.pushViewController(viewcon, animated: true)
            })
            .disposed(by: self.disposeBag)
        
        collectionView.rx.itemSelected
            .map { MainViewReactor.Action.selectedItemIndex($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        collectionView.rx.contentOffset
            .filter { _ in reactor.requestModel.page != -1 }
            .filter { _ in !reactor.isLoadingNextPage }
            .filter { [weak self] offset in
                guard let self = self,
                      self.collectionView.frame.height < self.collectionView.contentSize.height,
                      offset.y > 80 else { return false }
                return offset.y + self.collectionView.frame.height >= self.collectionView.contentSize.height - 80
            }
            .do(onNext: { _ in
                reactor.isLoadingNextPage = true
            })                
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func actSearchBar() {
        searchBar.resignFirstResponder()
    }
    
    @objc private func loadData() {
        guard let _reactor = self.reactor else { return }
        Observable.just(MainViewReactor.Action.searchText(searchBar.text ?? ""))
            .bind(to: _reactor.action)
            .disposed(by: self.disposeBag)
        self.timer = nil
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer?.invalidate()
        self.timer = nil
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loadData), userInfo: nil, repeats: false)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar(searchBar, textDidChange: "")
    }
}

enum MainListItem: Equatable {
    case image(reactor: MainListItemReactor)
}

struct MainListSection: Equatable {
    var mainList: [MainListItem]
        

    init(items: [MainListItem]) {
        self.mainList = items
    }
    
    static func == (lhs: MainListSection, rhs: MainListSection) -> Bool {
        lhs.items == rhs.items
    }
}

extension MainListSection: SectionModelType {
    typealias Item = MainListItem
    
    var items: [MainListItem] {
        set {
            self.mainList = newValue
        }
        
        get {
            self.mainList
        }
    }

    init(original: MainListSection, items: [MainListItem]) {
        self = original
        self.mainList = items
    }
}
