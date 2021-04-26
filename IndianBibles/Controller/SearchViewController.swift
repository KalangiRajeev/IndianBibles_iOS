//
//  SearchViewController.swift
//  IndianBibles
//
//  Created by Admin on 25/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating {
    
    var sectionVerses : [[Bible]] = [[Bible]]()
    var sectionsIndex : [Int] = [Int]()
    
    var queriedVerses : [Bible]? {
        didSet {
            sectionsIndex.removeAll()
            queriedVerses!.forEach({ (bible) in
                sectionsIndex.append(bible.book ?? 0)
            })
            sectionsIndex.removeDuplicates()
            
            sectionsIndex.forEach { (index) in
                sectionVerses.append(queriedVerses!.filter { (bible) -> Bool in
                    return bible.book == index
                })
            }
            
        }
    }
    
    var queryString : String?
    let bibleBooks = BibleBooks()

    let db = DBHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let count = queriedVerses?.count {
            navigationItem.title = "\(count) Search Results"
        }
        tableView.sectionHeaderHeight = CGFloat(50)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search"
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text != "" {
            if let queryText = searchController.searchBar.text {
                queryString = queryText
                queriedVerses = db.getQueriedVerses(search: queryText)
                if let count = queriedVerses?.count {
                    navigationItem.title = "\(count) Search Results"
                }
                tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsIndex.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "\(self.bibleBooks.englishBooks[sectionsIndex[section]]) (\(sectionVerses[section].count) Verses)"
        return title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionVerses[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SVCell", for: indexPath)
        
        let row = indexPath.row
        let section = indexPath.section
        
        if let chapter = sectionVerses[section][row].chapter, let verse = sectionVerses[section][row].verse, let verseDesc =  sectionVerses[section][row].verseDesc {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "(\(indexPath.row + 1)) \(chapter):\(verse) - \(verseDesc)"
            cell.textLabel?.highlight(text: queryString, color: UIColor.red)
        }
        return cell
    }
    
}
