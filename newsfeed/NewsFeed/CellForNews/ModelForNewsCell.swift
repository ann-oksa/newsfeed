//
//  ModelForNewsCell.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 22.02.2021.
//

import Foundation

protocol ModelForNewsCellDelegate: class {
    func didFinishLoadImageData(_ data: Data?)
}

class ModelForNewsCell {
    
    let article: Article
    let url: String
    let autor: String
    let title: String
    let content: String
    let source: String
    let imageURL: String
    var dataForImage : Data? 
    var date = Date()
    var stringDateForShowingTimeAgo = String()
    
    weak var delegate: ModelForNewsCellDelegate?
    
    init(article: Article) {
        self.article = article
        self.url = article.url
        self.autor = article.author ?? "Some autor"
        self.title = article.title
        self.content = article.content ?? "Some text"
        self.source = article.source.name
        self.imageURL = article.urlToImage ?? "Some string"
        if let rightDate = convertDateStringToDate(inputDate: article.publishedAt) {
            date = rightDate
        }
        stringDateForShowingTimeAgo = date.timeAgoDisplay()
        
        loadDataForImage(stringForImage: imageURL)
    }
    
    func loadDataForImage(stringForImage: String) {
        guard let url = URL(string: stringForImage) else {
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                self.dataForImage = data
                DispatchQueue.main.async {
                    self.delegate?.didFinishLoadImageData(self.dataForImage)
                }
            }
            catch {
                print("ModelForNewsCell -> createDataForImage -> can`t get data from url:  \(error.localizedDescription)")
            }
        }
    }
    
    func convertDateStringToDate(inputDate: String ) -> Date? {
        let isoDate = inputDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let outputDate = dateFormatter.date(from:isoDate)
        return outputDate
    }
    
    
}
