//
//  DetailsViewControllerCoordinator.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 18.03.2021.
//

import UIKit

class DetailsViewControllerCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var detailsViewController: DetailsViewController?
    private var article: Article
    
    
    init(presenter: UINavigationController, article: Article) {
        self.presenter = presenter
        self.article = article
    }
    
    
    
    func start() {
        let viewModel = DetailsViewModel(article: article)
        let detailsViewController = DetailsViewController(viewModel: viewModel)
        presenter.pushViewController(detailsViewController, animated: true)
        self.detailsViewController = detailsViewController
    }
    
    
}
