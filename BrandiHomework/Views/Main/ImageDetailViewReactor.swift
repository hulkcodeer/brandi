//
//  ImageDetailViewReactor.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/23.
//

import ReactorKit

internal final class ImageDetailViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var itemInfo: MainListItem
    }
    
    let initialState: State
        
    init(item: MainListItem) {
        initialState = State(itemInfo: item)
    }
}
