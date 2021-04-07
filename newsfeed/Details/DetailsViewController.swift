//
//  DetailsViewController.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 18.03.2021.
//

import UIKit
import WebKit

class DetailsViewController: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    let detailsViewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.detailsViewModel = viewModel
        super.init(nibName: "DetailsViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsViewModel.delegate = self
        
        title = detailsViewModel.articleTitle
        webView.load(detailsViewModel.myRequestForShowingNews())
        
        createToFavoriteButton()
    }
    
    
}

extension DetailsViewController: DetailsViewModelDelegate {
    
    func favoriteListHasAlreadyHadThisArticle() {
        let alert = UIAlertController(title: nil,
                                      message: detailsViewModel.messageHaveAlreadyHadArticle,
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: detailsViewModel.messageOkCool,
                                     style: .default,
                                     handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

extension DetailsViewController {
    
    func createToFavoriteButton() {
        let toFavoriteImage = UIImage(systemName: "star.fill")
        let buttonAddToFavorites = UIBarButtonItem(image: toFavoriteImage,
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(saveArticleClicked))
        buttonAddToFavorites.tintColor = .availableColor
        navigationItem.rightBarButtonItem = buttonAddToFavorites
    }
    
    @objc func saveArticleClicked() {
        detailsViewModel.saveArticle()
    }
    
    
}
