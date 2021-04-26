//
//  ViewController.swift
//  IndianBibles
//
//  Created by Admin on 24/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController, UISearchBarDelegate {
    
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 2
    
    let db = DBHandler()
    let bibleBooks = BibleBooks()
    var queriedVerses : [Bible]?
    var queryString : String?

    
    @IBOutlet weak var booksCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booksCollectionView.dataSource = self
        booksCollectionView.delegate = self
        navigationItem.title = "English Bible"
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != "" {
            if let queryText = searchBar.text {
                queryString = queryText
                queriedVerses = db.getQueriedVerses(search: queryText)
                performSegue(withIdentifier: "BooksToSearch", sender: self)
            }
        }
    }
    
}


extension BooksViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bibleBooks.englishBooks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = booksCollectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CollectionViewCell
            cell.cellTitle.text = self.bibleBooks.englishBooks[indexPath.item]
            cell.cellSubtitle.text = String(self.db.getChaptersCount(book: indexPath.item)) + " Chapters"
        return cell
    }
}


extension BooksViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BooksToChapters", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BooksToChapters" {
            let controller = segue.destination as! ChaptersViewController
            if let indexPaths = booksCollectionView.indexPathsForSelectedItems {
                controller.selectedBookIndex = indexPaths[0].item
            }
        } else if segue.identifier == "BooksToSearch" {
            let controller = segue.destination as! SearchViewController
            controller.queriedVerses = self.queriedVerses
            controller.queryString = self.queryString
        }
    }
}


extension BooksViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }

}


