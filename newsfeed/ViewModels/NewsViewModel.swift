//
//  NewsViewModel.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 15.02.2021.
//

import Foundation
import CoreGraphics

protocol NewsViewModelDelegate: class {
    func updateDataForShowingNews()
    func stateChanged(state: NewsViewModel.DataAvailabilityState )
}

class NewsViewModel {
    
    enum DataAvailabilityState {
        case empty
        case loading
        case available
        
    }
    
    
    var lastUpdate: Date?
    weak var delegate: NewsViewModelDelegate?
    var everything = GoogleNewsEverythingRequest(topic: "COVID-19", dateFrom: "2021-03-05", dateTo: "2021-03-05", sortCriteria: .popularity)
    
    var modelsForNewsCell = [ModelForNewsCell]()
    let googleNewsAPI: GoogleNewsAPI
    var dataState : DataAvailabilityState {
        didSet {
            delegate?.stateChanged(state: dataState)
        }
    }
    
    init(googleNewsAPI: GoogleNewsAPI) {
        self.googleNewsAPI = googleNewsAPI
        self.dataState = .empty
    }
    
    var isInternetOn = true
    
    func behaviorOfScreenIf(networkStatus: Bool ) {
        if networkStatus == false {
           // dataState = .loading
            // show last available news
            print("show last available news")
        }
        else {
            //show newest news
            print("show newest news")
            showNewsByEverythingRequest()
            
        }
    }
    
    
    func showNewsByEverythingRequest() {
        
        self.dataState = .loading
        googleNewsAPI.fetchEverythingRequest(googleNewsEverythingRequest: everything) { (response) in
            
            switch response {
            case .success(let result) :
                var indexOfAppendingArticle: Int = 0
                for article in result.articles {
                    let modelForNewsCell = ModelForNewsCell(article: article)
               //     print(article[1].pu)
                    self.modelsForNewsCell.append(modelForNewsCell)
                    indexOfAppendingArticle += 1
                    if indexOfAppendingArticle > self.everything.pageSize - 1 {
                        break
                    }
                }
                self.lastUpdate = Date()
                print("lastUpdate: \(String(describing: self.lastUpdate?.timeAgoDisplay()))")
                self.dataState = .available
                
               
            case .failure(let error) :
                print("NewsViewModel -> showNewsByEverythingRequest -> can`t get successful result frrom response. Error \(error.code): \(error.message)")
                self.dataState = self.modelsForNewsCell.isEmpty ? .empty : .available
            }
            
            self.delegate?.updateDataForShowingNews()
        }
    }
    
    func calculateItemSize(for itemNumber: Int,
                           in boxSize: CGSize,
                           minHeight: CGFloat = 220,
                           horisontalSpasing: CGFloat = 10) -> CGSize {
        let fullWidth = boxSize.width
        let itemsCountForVerticalLayout: CGFloat = 2
        let itemsCountForHorisontalLayout: CGFloat = 3
        let fullWidthItemMask  = 7
        var ItemsInRRow = CGFloat( itemsCountForVerticalLayout)
        
        if boxSize.width >  boxSize.height {
            ItemsInRRow = CGFloat( itemsCountForHorisontalLayout)
        }
        let width = (boxSize.width - horisontalSpasing * (ItemsInRRow + 1)) / ItemsInRRow
        
        if (itemNumber + fullWidthItemMask) % fullWidthItemMask == 0 {
            return  CGSize(width: fullWidth, height: minHeight)
        }
        return  CGSize(width: width, height: minHeight)
        
    }
    
    // мне нужно ооздать метод, который менял бы состояние экрана в зависимоти от значения
    // есть два состояния: есть интернет, нет интернета
    // когда есть интернет, я могу иметь статус пустоты, когда нет данных, статус загрузки, статус отображения новых  данных
    // когда нет интернета, я могу иметь статус отображения старых данных
    //
}



extension Date {
    func timeAgoDisplay() -> String {

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!

        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "\(diff) sec ago"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff) min ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff) hrs ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff) days ago"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
        return "\(diff) weeks ago"
    }
}
