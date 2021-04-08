//
//  File.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 12.02.2021.
//

// struct with parameters for everything request

import Foundation

struct GoogleNewsEverythingRequest: CreatorQueryItemsProtocol {
   //page page size
    enum SortCriteria: String {
        case popularity = "popularity"
        case relevancy = "relevancy"
        case publishedAt = "publishedAt"
    }
    
    var topic: String
    let dateFrom: String
    let dateTo: String
    let sortCriteria: SortCriteria
    let pageSize = 22
    let page = 1
}

extension GoogleNewsEverythingRequest {

    func createdQueryItemsFromParameters() -> [URLQueryItem] {
        return [
            URLQueryItem(name: "q", value: self.topic),
            URLQueryItem(name: "from", value: self.dateFrom),
            URLQueryItem(name: "to", value: self.dateTo),
            URLQueryItem(name: "sortBy", value: self.sortCriteria.rawValue),
            URLQueryItem(name: "pageSize", value: "\(self.pageSize)"),
            URLQueryItem(name: "page", value: "\(self.page)"),

        ]
    }
}
