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
    
    
    var requestText = "Grammy"
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
    
    
    
    func showNewsByEverythingRequest(with text: String) {
        
        requestText = text
        let currentDate = Date().convertDateToString(from: Date())
        let twoDaysAgo = Date().dateTwoDaysAgo()
        let newsRequest = GoogleNewsEverythingRequest(topic: requestText, dateFrom: currentDate, dateTo: twoDaysAgo , sortCriteria: .popularity)
        
        modelsForNewsCell = []
        self.dataState = .loading
        googleNewsAPI.fetchNewsByRequest(newsRequest) { (response) in
            
            switch response {
            case .success(let result) :
                var indexOfAppendingArticle: Int = 0
                for article in result.articles {
                    let modelForNewsCell = ModelForNewsCell(article: article)
                    // modelsForNewsCell = []
                    self.modelsForNewsCell.append(modelForNewsCell)
                    indexOfAppendingArticle += 1
                    if indexOfAppendingArticle > newsRequest.pageSize - 1 {
                        break
                    }
                }
                self.lastUpdate = "Last update: \(String(describing: Date().timeAgoDisplay() ))"
                self.titleForNews = newsRequest.topic
                self.delegate?.setTitleForNews(newsTitle: self.titleForNews)
                self.dataState = .available
                
                
            case .failure(let error) :
                print("NewsViewModel -> showNewsByEverythingRequest -> can`t get successful result frrom response. Error \(error.code): \(error.message)")
                self.dataState = self.modelsForNewsCell.isEmpty ? .empty : .available
            }
            
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



