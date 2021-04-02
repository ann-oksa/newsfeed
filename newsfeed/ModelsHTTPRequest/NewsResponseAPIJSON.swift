//
//  Constants.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 08.02.2021.
//

import Foundation

// MARK: - NewsResponse
struct NewsResponse: Codable, Hashable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Hashable {
    
    let source: ArticleSource
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct ArticleSource: Codable, Hashable {
    let id: String?
    let name: String
}
