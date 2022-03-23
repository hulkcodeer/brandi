//
//  SearchFilterModel.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/23.
//

import Foundation

enum SortType: String {
    case accuracy = "accuracy"
    case recency = "recency"
}

internal struct SearchFilterModel: Equatable {
    var query: String = ""
    var sort: SortType = .accuracy
    var page: Int = 1
    var size: Int = 30
}
