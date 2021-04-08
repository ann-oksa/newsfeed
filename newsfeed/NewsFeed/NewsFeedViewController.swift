//
//  NewsFeedViewController.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 17.02.2021.
//

import UIKit

protocol NewsFeedViewControllerDelegate: class {
    func newsFeedViewControllerDidSelectArticle(withUrl: String, withArticle: Article)
    func newsFeedViewControllerDidSelectFavorites()
}

class NewsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewsViewModelDelegate {
    
    
    @IBOutlet weak var lastUpdateLAbel: UILabel!
    @IBOutlet weak var networkStatusLabel: UILabel!
    @IBOutlet weak var reconnectButton: UIButton!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var indicatorrOfDownloading: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewOfNews: UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    let newsViewModel: NewsViewModel
    weak var delegate: NewsFeedViewControllerDelegate?
    
    init(viewModel: NewsViewModel) {
        self.newsViewModel = viewModel
        super.init(nibName: "NewsFeedViewController", bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewOfNews.delegate = self
        collectionViewOfNews.dataSource = self
        newsViewModel.delegate = self
        
        let  nib = UINib(nibName: CollectionViewCell.reuseIdentifier, bundle: nil)
        collectionViewOfNews.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        stateChanged(state: newsViewModel.dataState)
        self.newsViewModel.showNewsByEverythingRequest(with: newsViewModel.requestText)
        
        createToFavoriteArticleListButton()
        setSearchControllerSettings()
        
    }
    
    @IBAction func reconnectClicked(_ sender: UIButton) {
        stateChanged(state: newsViewModel.dataState)
        newsViewModel.showNewsByEverythingRequest(with: newsViewModel.requestText)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionViewOfNews.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsViewModel.modelsForNewsCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewOfNews.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as! CollectionViewCell
        let cellViewModel = newsViewModel.modelsForNewsCell[indexPath.row]
        cell.fill(news: cellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = newsViewModel.modelsForNewsCell[indexPath.row].url
        let article = newsViewModel.modelsForNewsCell[indexPath.row].article
        delegate?.newsFeedViewControllerDidSelectArticle(withUrl: url, withArticle: article)
    }
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let itemSizeForEachCell = newsViewModel.calculateItemSize(for: indexPath.row, in: collectionViewOfNews.frame.size)
        layout.itemSize =  itemSizeForEachCell
        return  layout.itemSize
    }
}

extension NewsFeedViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func setSearchControllerSettings() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "News, music, books..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        
        self.navigationItem.titleView = searchController.searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            newsViewModel.showNewsByEverythingRequest(with: text)
        }
        collectionViewOfNews.reloadData()
    }
    
}

extension NewsFeedViewController {
    
    func createToFavoriteArticleListButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(toFavoriteListClicked))
        navigationItem.rightBarButtonItem?.tintColor = .availableColor
    }
    
    @objc func toFavoriteListClicked() {
        delegate?.newsFeedViewControllerDidSelectFavorites()
    }
    
    func updateDataForShowingNews() {
        collectionViewOfNews.reloadData()
    }
    
    func networkStatusDidChanged(status: Bool) {
        if status == true {
            networkStatusLabel.backgroundColor = .black
        } else {
            networkStatusLabel.backgroundColor = .red
        }
    }
    
    func setTitleForNews(newsTitle: String) {
        title = newsTitle
    }
    
    func stateChanged(state: NewsViewModel.DataAvailabilityState) {
        collectionViewOfNews.reloadData()
        switch state {
        
        case .empty:
            connectionStatusLabel.text = "Can`t get data from server, try again"
            indicatorrOfDownloading.isHidden = true
            collectionViewOfNews.isHidden = true
            reconnectButton.isHidden = false
            view.backgroundColor = .emptyColor
            
        case .loading:
            connectionStatusLabel.text = "Loading..."
            indicatorrOfDownloading.isHidden = false
            indicatorrOfDownloading.startAnimating()
            collectionViewOfNews.isHidden = true
            reconnectButton.isHidden = true
            view.backgroundColor = .loadingColor
            
        case .available:
            indicatorrOfDownloading.isHidden = true
            indicatorrOfDownloading.stopAnimating()
            connectionStatusLabel.isHidden = true
            collectionViewOfNews.isHidden = false
            reconnectButton.isHidden = true
            view.backgroundColor = .availableColor
            collectionViewOfNews.backgroundColor = .availableColor
            lastUpdateLAbel.text = newsViewModel.lastUpdate
        }
    }
}

extension UIColor {
    static  let availableColor = UIColor(red: 105.0/255.0, green: 130.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static  let loadingColor = UIColor(red: 125.0/255.0, green: 190.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    static  let emptyColor = UIColor(red: 195.0/255.0, green: 130.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    
}

