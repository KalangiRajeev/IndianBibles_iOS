//
//  LinkRefViewController.swift
//  IndianBibles
//
//  Created by Admin on 28/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import UIKit

class LinkRefViewController: UITableViewController {
    
    var qVerse : Bible? 
    var linkedVerses: [Bible]? {
        didSet{
            tableView.reloadData()
        }
    }
    var linkedVersesManager = LinkedVersesManager()
    let bibleBooks = BibleBooks()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let sVerse = qVerse {
            linkedVerses = linkedVersesManager.getLinkedReferences(queriedVerse: sVerse)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkedVerses?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
        
        
        if let sVerses = linkedVerses, let book = linkedVerses?[indexPath.row].book, let chapter = sVerses[indexPath.row].chapter, let verse =  sVerses[indexPath.row].verse {
            
            cell.textLabel?.numberOfLines = 0
            switch BooksSingleton.booksSingleton.selectedBible {
            case "bible_telugu" :
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.teluguBooks[book]) - (\(chapter): \(verse))"
            case "bible_tamil" :
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.tamilBooks[book]) - (\(chapter): \(verse))"
            case "bible_hindi" :
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.hindiBooks[book]) - (\(chapter): \(verse))"
            case "bible_kannada" :
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.kannadaBooks[book]) - (\(chapter): \(verse))"
            case "bible_malayalam" :
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.malayalamBooks[book]) - (\(chapter): \(verse))"
            default:
                cell.detailTextLabel?.text =  "(\(indexPath.row+1)).\(bibleBooks.englishBooks[book]) - (\(chapter): \(verse))"
            }
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = sVerses[indexPath.row].verseDesc
        }
        
        
        return cell
    }
    
}
