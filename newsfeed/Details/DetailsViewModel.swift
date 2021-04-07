//
//  DetailsViewModel.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 18.03.2021.
//
//


import Foundation

protocol FileManagerWritingAndReadingArticle {
    func readArticles() -> [Article]?
    func writeArticles(_ articles: [Article])
}

protocol DetailsViewModelDelegate: class {
    func favoriteListHasAlreadyHadThisArticle()
}

class DetailsViewModel {
    
    private let articlesGateway =  ArticlesGateway()
    private var article: Article
    private var favoriteArticles = [Article]()
    weak var delegate: DetailsViewModelDelegate?
    var articleTitle : String
    let messageHaveAlreadyHadArticle = "You have already had this article in favorite list!"
    let messageOkCool = "OK, cool!"
    
    init(article: Article) {
        self.article = article
        self.articleTitle = article.title
    }
    
    func myRequestForShowingNews() -> URLRequest {
        let myURL = URL(string: article.url)
        let myRequest = URLRequest(url: myURL!)
        return myRequest
    }
    
    func saveArticle() {
        guard let savedArticleList = articlesGateway.readArticles() else {
           addArticleToList()
            return
        }
        favoriteArticles = savedArticleList
        if favoriteArticles.contains(article) {
            delegate?.favoriteListHasAlreadyHadThisArticle()
        } else {
            addArticleToList()
        }
    }
    
    private func addArticleToList() {
        favoriteArticles.append(article)
        articlesGateway.writeArticles(favoriteArticles)
    }
}
