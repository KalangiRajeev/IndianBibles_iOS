//
//  VersesViewController.swift
//  IndianBibles
//
//  Created by Admin on 25/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class VersesViewController: UITableViewController, UISearchBarDelegate {
    
    var selectedBookIndex: Int?
    var selectedChapterIndex: Int?
    var bibleVerses: [Bible]?
    
    let db = DBHandler()
    var queriedVerses : [Bible]?
    var queryString : String?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let chapter = selectedChapterIndex {
            navigationItem.title = "Chapter \(chapter)"
        }
        tableView.separatorStyle = .singleLine
        
        if let book = selectedBookIndex, let chapter = selectedChapterIndex {
           bibleVerses = db.getVerses(book: book, chapter: chapter)
        }
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = true
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
                performSegue(withIdentifier: "VersesToSearch", sender: self)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VersesToSearch" {
             let controller = segue.destination as! SearchViewController
                controller.queriedVerses = self.queriedVerses
            controller.queryString = self.queryString
        }
    }

    
}


// MARK: - Table view data source
extension VersesViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bibleVerses?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        if let bible = self.bibleVerses?[indexPath.row] {
            cell.textLabel?.text = "(\(indexPath.row + 1)) \(bible.verseDesc!)"
//            cell.detailTextLabel?.text = "Verse \(String(bible.verse))"
        }
        return cell
    }
}
