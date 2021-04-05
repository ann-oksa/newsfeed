//
//  FavoritesViewController.swift
//  newsfeed
//
//  Created by Anna Oksanichenko on 24.03.2021.
//

import UIKit

protocol FavoritesViewControllerDelegate: class {
    func favoritesViewControllerDidSelectArticle(_ article: Article )
}

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    let favoritesViewModel: FavoritesViewModel
    weak var delegate: FavoritesViewControllerDelegate?
    
    init(viewModel: FavoritesViewModel) {
        self.favoritesViewModel = viewModel
        super.init(nibName: "FavoritesViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageLabel.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        favoritesViewModel.delegate = self
        
        title = favoritesViewModel.title
        
        let  nib = UINib(nibName: FavoritesTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: FavoritesTableViewCell.reuseIdentifier)
        stateChanged(state: .empty)
        updateDataForShowingNews()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.reuseIdentifier, for: indexPath) as! FavoritesTableViewCell
        let cellViewModel = favoritesViewModel.articles[indexPath.row]
        cell.fill(news: cellViewModel.title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = favoritesViewModel.articles[indexPath.row]
        delegate?.favoritesViewControllerDidSelectArticle(article)
        
    }
 
}

extension FavoritesViewController: FavoriteViewModelProtocol {
    
    func updateDataForShowingNews() {
        print("reload")
        tableView.reloadData()
        
    }
    
    func stateChanged(state: FavoritesViewModel.FavoriteListAvailabilityState) {
        tableView.reloadData()
            switch state {
            case .empty:
                print("no such file")
                self.tableView.isHidden = true
                self.messageLabel.isHidden = false
                self.messageLabel.text = self.favoritesViewModel.messageNoFavoriteArticles
                self.tableView.reloadData()
                
            case .available:
                print("available")
                self.tableView.isHidden = false
                self.messageLabel.isHidden = true
                self.tableView.reloadData()

            
        }
     
    }
    
}
