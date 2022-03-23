//
//  MainItemReactor.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

import ReactorKit

internal final class MainListItemReactor: Reactor, Equatable {
    
    typealias Action = NoAction
    typealias Mutation = NoMutation
    
    struct State {
        var model: Document
    }
    
    let initialState: State
    
    init(model: Document) {
        defer { _ = self.state }
        self.initialState = State(model: model)
    }
    
    static func == (lhs: MainListItemReactor, rhs: MainListItemReactor) -> Bool {
        return lhs.initialState.model == rhs.initialState.model
    }
}
