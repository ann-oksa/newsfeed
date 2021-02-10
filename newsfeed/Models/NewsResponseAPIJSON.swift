//
//  ModelNewsAPI.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 08.02.2021.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: ArticleSource
    let author, title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: Date
    let content: String

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

struct ArticleSource: Codable {
    let id: String?
    let name: String
}
