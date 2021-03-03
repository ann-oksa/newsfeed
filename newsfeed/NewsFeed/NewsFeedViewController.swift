//
//  NewsFeedViewController.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 17.02.2021.
//

import UIKit

class NewsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewsViewModelDelegate {
 
 
    @IBOutlet weak var connectionStatusLabel: UILabel!
    @IBOutlet weak var indicatorrOfDownloading: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewOfNews: UICollectionView!
    
    let newsViewModel: NewsViewModel
    let collectionViewCell = CollectionViewCell()
    
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
        isLoadingInProgress(loading: newsViewModel.isIndicatorOfDownloadingHidden)

        let  nib = UINib(nibName: CollectionViewCell.reuseIdentifier, bundle: nil)
        collectionViewOfNews.register(nib, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        self.newsViewModel.showNewsByEverythingRequest()
        indicatorrOfDownloading.isHidden = newsViewModel.isIndicatorOfDownloadingHidden

        
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
    
}

extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
    
    func setConnectionState(state: NewsViewModel.DataAvailabilityState) {
        switch state {
        case .noData:
            print("no data")
            self.connectionStatusLabel.text = "Can`t get data from server, try again"
           collectionViewOfNews.isHidden = true
            view.backgroundColor = .red
            
        case .inProgress:
            DispatchQueue.main.async {
                self.collectionViewOfNews.isHidden = true
                self.view.backgroundColor = .green

            }
            
        print("in progress")
        case .done:
            self.connectionStatusLabel.isHidden = true
            self.collectionViewOfNews.isHidden = false
            self.view.backgroundColor = .blue
            collectionViewOfNews.backgroundColor = .blue
        print("done")
    }
    
    }
 
    
    func isLoadingInProgress(loading: Bool) {
        DispatchQueue.main.async {
            self.indicatorrOfDownloading.isHidden = self.newsViewModel.isIndicatorOfDownloadingHidden
            print(self.indicatorrOfDownloading.isHidden)
            self.indicatorrOfDownloading.isHidden ? self.indicatorrOfDownloading.stopAnimating() : self.indicatorrOfDownloading.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        let itemSizeForEachCell = newsViewModel.calculateItemSize(for: indexPath.row, in: collectionViewOfNews.frame.size)
        layout.itemSize =  itemSizeForEachCell
        return  layout.itemSize
        
    }
    
    func updateDataForShowingNews() {
        collectionViewOfNews.reloadData()
    }
    
}

