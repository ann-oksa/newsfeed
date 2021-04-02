//
//  FavoritesViewControllerCoordinator.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 24.03.2021.
//

import UIKit

class FavoritesViewControllerCoordinator: Coordinator, FavoritesViewControllerDelegate {
    
    
    private let presenter: UINavigationController
    private var favoritesViewController: FavoritesViewController?
    private var detailsViewControllerCoordinator: DetailsViewControllerCoordinator?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    
    
    func start() {
        let viewModel = FavoritesViewModel()
        let favoritesViewController = FavoritesViewController(viewModel: viewModel)
        favoritesViewController.delegate = self
        presenter.pushViewController(favoritesViewController, animated: true)
        self.favoritesViewController = favoritesViewController
    }
    
    func favoritesViewControllerDidSelectArticle(_ article: Article) {
        let detailsViewControllerCoordinator  = DetailsViewControllerCoordinator(presenter: presenter, article: article)
        detailsViewControllerCoordinator.start()
        self.detailsViewControllerCoordinator = detailsViewControllerCoordinator
    }
    
    
}
