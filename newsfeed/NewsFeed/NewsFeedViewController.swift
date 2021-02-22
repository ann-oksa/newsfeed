//
//  NewsFeedViewController.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 17.02.2021.
//

import UIKit

class NewsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NewsViewModelDelegateProtocol {
   
    
    @IBOutlet weak var collectionViewOfNews: UICollectionView!
    
   
    let identifier = Identifiers()
    let newsViewModel: NewsViewModel
    
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

        let  nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        collectionViewOfNews.register(nib, forCellWithReuseIdentifier: identifier.identifierForCell)
        
        self.newsViewModel.test() 
        
        
        
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let flowLayout = collectionViewOfNews.collectionViewLayout as? UICollectionViewFlowLayout else {
           return
         }
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            flowLayout.itemSize = CGSize(width: 220, height: 220)
          } else {
            flowLayout.itemSize = CGSize(width: 192, height: 192)
          }

          flowLayout.invalidateLayout()
       
    }
    
    
    func updatingData() {
        collectionViewOfNews.reloadData()
    }
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsViewModel.modelsForNewsCell.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewOfNews.dequeueReusableCell(withReuseIdentifier: identifier.identifierForCell, for: indexPath) as! CollectionViewCell
        let cellViewModel = newsViewModel.modelsForNewsCell[indexPath.row]
        cell.fill(news: cellViewModel)
        return cell
    }

}
