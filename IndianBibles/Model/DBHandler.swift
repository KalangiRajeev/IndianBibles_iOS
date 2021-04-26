//
//  DBHandler.swift
//  first design
//
//  Created by Haris Mir on 23/10/2019.
//  Copyright © 2019 haris. All rights reserved.
//

import Foundation
import SQLite3

class DBHandler {
    
    let databaseName : String = "indian_bibles"
    let databaseExtension : String = "db"
    var db : OpaquePointer! = nil
    
    init() {
         prepareDatafile()
         db = openDatabase()
    }
    
    //Copy database for fist time
    func prepareDatafile()
    {
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).\(databaseExtension)")
        let filemanager=FileManager.default
        
        if !FileManager.default.fileExists(atPath: fdoc_url.path){
            do{
                let localUrl=Bundle.main.url(forResource: databaseName, withExtension: databaseExtension)
                print(localUrl?.path ?? "")
                try filemanager.copyItem(atPath: (localUrl?.path)!, toPath: fdoc_url.path)
                print("Database copied to simulator-device")
            }catch
            {
                print("error while copying")
            }
        }
        else{
            print("Database alreayd exists in similator-device")
        }
    }
    
    
    // Open Connection to Database
    func openDatabase() -> OpaquePointer? {
        
        let docUrl=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(docUrl)
        let fdoc_url=URL(fileURLWithPath: docUrl).appendingPathComponent("\(databaseName).\(databaseExtension)")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fdoc_url.path, &db) == SQLITE_OK {
            print("DB Connection Opened, Path is :: \(fdoc_url.path)")
            return db
        } else {
            print("Unable to open database. Verify that you created the directory described in the Getting Started section.")
            return nil
        }
        
    }
    
    func getVerses(selectedBible: String = "bible_english", book:Int, chapter: Int) -> [Bible]?{
        var bibleVerses = [Bible]()
        let query = "SELECT * FROM \(selectedBible) WHERE Book = \(book) AND Chapter = \(chapter);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var data = Bible()
                data.book = Int(sqlite3_column_int(queryStatement, 0))
                data.chapter = Int(sqlite3_column_int(queryStatement, 1))
                data.verse = Int(sqlite3_column_int(queryStatement, 2))
                data.verseDesc = String(cString: sqlite3_column_text(queryStatement, 3))
                data.verseId = Int(sqlite3_column_int(queryStatement, 4))
                bibleVerses.append(data)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error Message : \(errmsg)")
        }
        sqlite3_finalize(queryStatement!)
        return bibleVerses
    }
    
    func getQueriedVerses(selectedBible: String = "bible_english", search: String) -> [Bible]? {
        var bibleVerses = [Bible]()
        let query = "SELECT * FROM \(selectedBible) WHERE verse LIKE '%\(search)%';"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var data = Bible()
                        data.book = Int(sqlite3_column_int(queryStatement, 0))
                        data.chapter = Int(sqlite3_column_int(queryStatement, 1))
                        data.verse = Int(sqlite3_column_int(queryStatement, 2))
                        data.verseDesc = String(cString: sqlite3_column_text(queryStatement, 3))
                        data.verseId = Int(sqlite3_column_int(queryStatement, 4))
                        bibleVerses.append(data)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error Message : \(errmsg)")
        }
        sqlite3_finalize(queryStatement!)
        return bibleVerses
    }
    
    func getSelectedVerse(selectedBible: String = "bible_english", book:Int, chapter: Int, verse: Int) -> Bible {
        var selectedVerse = Bible()
        let query = "SELECT * FROM \(selectedBible) WHERE Book = \(book) AND Chapter = \(chapter) AND Versecount = \(verse);"
        
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                selectedVerse.book = Int(sqlite3_column_int(queryStatement, 0))
                selectedVerse.chapter = Int(sqlite3_column_int(queryStatement, 1))
                selectedVerse.verse = Int(sqlite3_column_int(queryStatement, 2))
                selectedVerse.verseDesc = String(cString: sqlite3_column_text(queryStatement, 3))
                selectedVerse.verseId = Int(sqlite3_column_int(queryStatement, 4))
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error Message : \(errmsg)")
        }
        defer {
            sqlite3_finalize(queryStatement!)
        }
        return selectedVerse
    }
        
    func getChaptersCount(selectedBible: String = "bible_english", book : Int) -> Int {
        var chaptersCount = Int()
        let query = "SELECT MAX(Chapter) FROM \(selectedBible) WHERE Book = \(book);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                chaptersCount = Int(sqlite3_column_int(queryStatement, 0))
            }
        } else {
            print ("Query in func getChaptersCount() Failed!")
        }
        return chaptersCount
    }
    
    func getVersesCount(selectedBible: String = "bible_english", bookNo: Int, chapterNo: Int) -> Int {
        var versesCount = Int()
        let query = "SELECT MAX(Versecount) FROM \(selectedBible) WHERE Book = \(bookNo) AND Chapter = \(chapterNo);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                versesCount = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        return versesCount
    }
    
    func executeQuery(query: String)->Bool{
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
            }
            else{
                return true
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    //++++++++++++++++++++++ Deleting from database++++++++++++++++++
    func deleteQuery(query: String)->Bool{
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure inserting hero: \(errmsg)")
            } else {
               return true
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("'insert into ':: could not be prepared::\(errmsg)")

        }
        sqlite3_finalize(deleteStatement)
        print("delete")
        return false
    }

}
