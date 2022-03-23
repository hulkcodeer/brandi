//
//  MainViewReactor.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import ReactorKit
import RxSwift
import Toaster

internal final class MainViewReactor: Reactor {
    
    enum Action {
        case searchText(String)
        case selectedItemIndex(IndexPath)
        case loadNextPage
    }
    
    enum Mutation {
        case setMainListSectionData([MainListItem])
        case setItemInfo(Int)
        case setNextPage([MainListItem])
        case none
    }
    
    struct State {
        var sections = [MainListSection]()
        var selectedItemInfo: MainListItem?
    }
    
    internal let provider: BrandiAPI
    internal let initialState: State
    internal var requestModel: SearchFilterModel = SearchFilterModel()
    internal var isLoadingNextPage = false
    
    private let disposeBag: DisposeBag = DisposeBag()
        
    init(provider: RestApi) {
        self.provider = provider
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {            
        case .searchText(let searchText):
            
            requestModel.query = searchText
            requestModel.page = 1
            
            return self.provider.fetchList(by: requestModel)
                         .asObservable()
                         .materialize()
                         .compactMap(self.convertToMainListData)
                         .compactMap(self.convertToSectionList)
                         .map { .setMainListSectionData($0) }
            
        case .loadNextPage:
            guard requestModel.page != -1 else { return .just(.none)}
            return self.provider.fetchList(by: requestModel)
                         .asObservable()
                         .materialize()
                         .compactMap(self.convertToMainListData)
                         .compactMap(self.convertToSectionList)
                         .map { .setNextPage($0) }
            
        case .selectedItemIndex(let indexPath):
            return .just(.setItemInfo(indexPath.row))
                           
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setMainListSectionData(let sectionItems):
            newState.sections = sectionItems.isEmpty ? [] : [MainListSection(items: sectionItems)]
            return newState
            
        case .setItemInfo(let index):
            newState.selectedItemInfo = self.currentState.sections.first?.items[index]
            return newState
            
        case .setNextPage(let sectionItems):
            guard var model = state.sections.first else { return newState }
            var currentItems = model.items
            currentItems.append(contentsOf: sectionItems)
            model.items = currentItems
            newState.sections = [model]
            return newState
            
        case .none: break
        }
        
        return newState
    }
    
    private func convertToSectionList(with model: SearchImageModel) -> [MainListItem] {
        var items: [MainListItem] = []
        
        guard let _documents = model.documents else { return []}
        for document in _documents {
            let cellReactor = MainListItemReactor(model: document)
            items.append(.image(reactor: cellReactor))
        }                
        return items
    }
    
    private func convertToMainListData(with event: Event<Data>) -> SearchImageModel? {
        switch event {
        case .next(let data):
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(SearchImageModel.self, from: data)
                guard let _meta = model.meta  else { return nil}
                self.requestModel.page = _meta.isEnd ? -1 : self.requestModel.page + 1
                printLog(out: "Data: \(model)")
                return model
            } catch {
                printLog(out: "\(error)")
                return nil
            }

        case .error(let error):
            if let errorResponse = error as? ApiError {
                printLog(out: "\(errorResponse.localizedDescription)")
                Toast(text: "검색 결과가 없습니다.", duration: 1).show()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    ToastCenter.default.cancelAll()
                })
            }
            return SearchImageModel(documents: nil, meta: nil)

        default:
            return nil
        }
    }
}
