//
//  SearchImageModel.swift
//  BrandiHomework
//
//  Created by 박현진 on 2022/03/22.
//

internal struct SearchImageModel: Decodable, Equatable {
    let documents: [Document]?
    let meta: Meta?
}

internal struct Document: Decodable, Equatable {
    let collection: String
    let dateTime: String
    let displaySiteName: String
    let docUrl: String
    let width: Int
    let height: Int
    let imageUrl: String
    let thumbnailUrl: String
    
    enum CodingKeys: String, CodingKey {
        case collection
        case dateTime = "datetime"
        case displaySiteName = "display_sitename"
        case docUrl = "doc_url"
        case width
        case height
        case imageUrl = "image_url"
        case thumbnailUrl = "thumbnail_url"
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        self.collection = try containter.decode(String.self, forKey: .collection)
        self.dateTime = try containter.decode(String.self, forKey: .dateTime)
        self.displaySiteName = try containter.decode(String.self, forKey: .displaySiteName)
        self.docUrl = try containter.decode(String.self, forKey: .docUrl)
        self.width = try containter.decode(Int.self, forKey: .width)
        self.height = try containter.decode(Int.self, forKey: .height)
        self.imageUrl = try containter.decode(String.self, forKey: .imageUrl)
        self.thumbnailUrl = try containter.decode(String.self, forKey: .thumbnailUrl)
    }
}

internal struct Meta: Decodable, Equatable {
    let isEnd: Bool
    let pageableCount: Int
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
    
    init(from decoder: Decoder) throws {
        let containter = try decoder.container(keyedBy: CodingKeys.self)
        self.isEnd = try containter.decode(Bool.self, forKey: .isEnd)
        self.pageableCount = try containter.decode(Int.self, forKey: .pageableCount)
        self.totalCount = try containter.decode(Int.self, forKey: .totalCount)
    }
}
