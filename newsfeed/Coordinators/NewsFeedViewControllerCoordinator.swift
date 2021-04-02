//
//  NewsFeedViewControllerCoordinator.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 17.02.2021.
//

import UIKit

class NewsFeedViewControllerCoordinator: Coordinator, NewsFeedViewControllerDelegate {
 
    
    private let presenter: UINavigationController
    private var newsFeedViewController: NewsFeedViewController?
    private var detailsViewControllerCoordinator: DetailsViewControllerCoordinator?
    private var favoritesViewControllerCoordinator: FavoritesViewControllerCoordinator?
    private let googleNewsAPI: GoogleNewsAPI
    
    
    
    init(presenter: UINavigationController, googleNewsAPI: GoogleNewsAPI) {
        self.presenter = presenter
        self.googleNewsAPI = googleNewsAPI
    }

    
    func start() {
     
        let viewModel = NewsViewModel(googleNewsAPI: googleNewsAPI)
        let newsFeedViewController = NewsFeedViewController(viewModel: viewModel)
        newsFeedViewController.delegate = self
        presenter.pushViewController(newsFeedViewController, animated: true)
        self.newsFeedViewController = newsFeedViewController
    }
    
    func newsFeedViewControllerDidSelectArticle(withUrl: String, withArticle: Article) {
        let detailsViewControllerCoordinator  = DetailsViewControllerCoordinator(presenter: presenter, article: withArticle)
        detailsViewControllerCoordinator.start()
        self.detailsViewControllerCoordinator = detailsViewControllerCoordinator
    }
    
    func newsFeedViewControllerDidSelectFavorites() {
        let favoritesViewControllerCoordinator = FavoritesViewControllerCoordinator(presenter: presenter)
        favoritesViewControllerCoordinator.start()
        self.favoritesViewControllerCoordinator = favoritesViewControllerCoordinator
    }
    
    
    
    
}
