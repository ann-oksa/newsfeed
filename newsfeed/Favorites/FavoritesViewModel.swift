//
//  FavoritesViewModel.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 24.03.2021.
//

import Foundation

protocol FavoriteViewModelProtocol: class {
    func stateChanged(_ state: FavoritesViewModel.FavoriteListAvailabilityState )
    func updateDataForShowingNews()
}

class FavoritesViewModel {
    
    enum FavoriteListAvailabilityState {
        case empty
        case available
        
    }
    
    var favoriteListState: FavoriteListAvailabilityState {
        
            didSet {
                delegate?.stateChanged(favoriteListState)
            }
        
        
    }
    
   private let articlesGateway =  ArticlesGateway()
    weak var delegate: FavoriteViewModelProtocol?
    //set observer
    var articles = [Article]()
    
    let title = "Favorites"
    let messageNoFavoriteArticles = "Sorry but there are no any favorite articles for you. But you can choose on main page. Good luck!"
    
    
    init() {
        if let articles = articlesGateway.readArticles() {
            self.articles = articles
            self.favoriteListState = .available
        } else {
            self.articles = []
            self.favoriteListState = .empty
            delegate?.updateDataForShowingNews()
        }
    }
}
