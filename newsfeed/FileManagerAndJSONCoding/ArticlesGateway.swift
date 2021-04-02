//
//  Saving.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 19.03.2021.
//

import Foundation

class ArticlesGateway: FileManagerWritingAndReadingArticle {
    
    private let localFileManager = LocalFileManager()
    
    func writeArticles(_ article: [Article]) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(article)
            localFileManager.createData(data)
        } catch {
            print ("NewsSaver -> saveArticle error \(error)")
        }
    }
    
    func readArticles() -> [Article]? {
        let decoder = JSONDecoder()
        guard let data = localFileManager.readData() else {
            return nil
        }
        do {
            let articles = try decoder.decode([Article].self, from: data)
            return articles
            
        } catch {
            print("NewsSaver -> readArticle error \(error)")
            return nil
        }
    }
}

