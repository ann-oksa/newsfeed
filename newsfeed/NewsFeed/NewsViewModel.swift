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
    func stateChanged(state: NewsViewModel.DataAvailabilityState)
    func networkStatusDidChanged(status: Bool)
    func setTitleForNews(newsTitle: String)
}

class NewsViewModel {
    
    enum DataAvailabilityState {
        case empty
        case loading
        case available
        
    }
    
    private  var everything = GoogleNewsEverythingRequest(topic: "Grammy", dateFrom: "2021-03-25", dateTo: "2021-03-25", sortCriteria: .popularity)
    
    var modelsForNewsCell = [ModelForNewsCell]()
    var titleForNews = String()
    let googleNewsAPI: GoogleNewsAPI
    var lastUpdate = String()
    weak var delegate: NewsViewModelDelegate?
    
    var dataState : DataAvailabilityState {
        didSet {
            delegate?.stateChanged(state: dataState)
        }
    }
    
    var isInternetOn = Network.reachability.isReachable {
        didSet {
            delegate?.networkStatusDidChanged(status: isInternetOn)
        }
    }
    
    init(googleNewsAPI: GoogleNewsAPI) {
        self.googleNewsAPI = googleNewsAPI
        self.dataState = .empty
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(self.statusManager),
                         name: .flagsChanged,
                         object: nil)
        // Since we  can`t check this notification with reachability on simulators, we run selector
        //  As input parameter we use random NSCalendarDayChanged because we don`t use it in our func
        statusManager(Notification(name: .NSCalendarDayChanged))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func statusManager(_ notification: Notification) {
        isInternetOn = Network.reachability.isReachable
        
        //This two dispatch we use only for test to check whether the status has changed because Reachability file doesn`t work on simulator
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.isInternetOn = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.isInternetOn = true
        })
    }
    
    func showNewsByEverythingRequest() {
        
        self.dataState = .loading
        googleNewsAPI.fetchEverythingRequest(googleNewsEverythingRequest: everything) { (response) in
            
            switch response {
            case .success(let result) :
                var indexOfAppendingArticle: Int = 0
                // print time unix
                for article in result.articles {
                    let modelForNewsCell = ModelForNewsCell(article: article)
                    self.modelsForNewsCell.append(modelForNewsCell)
                    indexOfAppendingArticle += 1
                    if indexOfAppendingArticle > self.everything.pageSize - 1 {
                        break
                    }
                }
                // print time unix
                
                
                self.lastUpdate = "Last update: \(String(describing: Date().timeAgoDisplay() ))"
                self.titleForNews = self.everything.topic
                self.delegate?.setTitleForNews(newsTitle: self.titleForNews)
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
        let fullRowSpace : CGFloat = 15
        
        
        if boxSize.width >  boxSize.height {
            ItemsInRRow = CGFloat( itemsCountForHorisontalLayout)
        }
        let width = (boxSize.width - horisontalSpasing * (ItemsInRRow + 1)) / ItemsInRRow
        
        if (itemNumber + fullWidthItemMask) % fullWidthItemMask == 0 {
            return  CGSize(width: fullWidth - fullRowSpace, height: minHeight)
        }
        return  CGSize(width: width, height: minHeight)
        
    }
    
}

extension Date {
    func timeAgoDisplay() -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            _ = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return "right now"
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

