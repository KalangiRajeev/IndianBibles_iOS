//
//  LinkedVersesManager.swift
//  IndianBibles
//
//  Created by Admin on 28/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import Foundation


struct LinkedVersesManager {
    
    let bookEngNames = ["GEN", "EXO", "LEV", "NUM", "DEU", "JOS", "JDG", "RUT", "1SA", "2SA", "1KI", "2KI",
                        "1CH", "2CH", "EZR", "NEH", "EST", "JOB", "PSA", "PRO", "ECC", "SOS", "ISA", "JER", "LAM", "EZE", "DAN",
                        "HOS", "JOE", "AMO", "OBA", "JON", "MIC", "NAH", "HAB", "ZEP", "HAG", "ZEC", "MAL", "MAT", "MAR", "LUK", "JOH", "ACT",
                        "ROM", "1CO", "2CO", "GAL", "EPH", "PHP", "COL", "1TH", "2TH", "1TI", "2TI", "TIT", "PHM", "HEB", "JAM",
                        "1PE", "2PE", "1JO", "2JO", "3JO", "JDE", "REV"]
    
    
    
    let db = DBHandler()
    var qString : String?
    
    
    mutating func getLinkedReferences(queriedVerse bible: Bible) -> [Bible]? {
        var queriedVerses = [Bible]()
        var verses = [String]()
        if let book = bible.book, let chapter = bible.chapter, let verse = bible.verse {
            self.qString = "\(bookEngNames[book]) \(chapter) \(verse)"
        }
        
        let json = readLocalFile()
        if let j = json {
            let data = parseJson(jsonData: j)
            if let sData = data {
               
                if sData.linkedVerses.contains(where: { (linkVerse) -> Bool in linkVerse.v == qString }) {
                    let index = sData.linkedVerses.firstIndex { (linkVerse) -> Bool in
                        linkVerse.v == qString
                    }
                    if let i = index {
                        if let sVerses = sData.linkedVerses[i].r?.verses {
                            verses.append(contentsOf: sVerses)
                        }
                    }
                }
                
                verses.forEach { (verse) in
                    let splitVerse = verse.components(separatedBy: " ")
                    let book = bookEngNames.firstIndex(of: splitVerse[0])
                    let chapter = splitVerse[1]
                    let verse = splitVerse[2]
                    
                    if let sBook = book  {
                        let bible = db.getSelectedVerse(selectedBible: BooksSingleton.booksSingleton.selectedBible, book: Int(sBook), chapter: Int(chapter) ?? 1, verse: Int(verse) ?? 1)
                        queriedVerses.append(bible)
                    }
                    
                }
            }
        }
        print (queriedVerses.count)
        return queriedVerses
    }
    
    
    func parseJson(jsonData: Data) -> LinkVerses? {
        do {
            let data = try JSONDecoder().decode(LinkVerses.self, from: jsonData)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    
    func readLocalFile(forName name: String = "cross_references") -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    
    
    func loadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
}
