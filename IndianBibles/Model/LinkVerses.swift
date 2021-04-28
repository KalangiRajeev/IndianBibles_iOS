//
//  LinkVerse.swift
//  IndianBibles
//
//  Created by Admin on 28/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import Foundation


struct LinkVerses : Decodable{
    
    let linkedVerses : [LinkVerse]
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [LinkVerse]()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(LinkVerse.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        linkedVerses = tempArray
    }
    
    
}

struct LinkVerse : Decodable {
    let v : String
    let r : Ref?
}

struct Ref : Decodable {
    let verses : [String]
    
    struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [String] ()
        
        for key in container.allKeys {
            let decodedObject = try container.decode(String.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        verses = tempArray
    }
}


//extension LinkVerses : Decodable {
//    enum CodingKeys: String, CodingKey {
//        case lookupVerseId
//    }
//}
//
//extension Ref : Decodable {
//    enum CodingKeys: String, CodingKey {
//        case resultVerseId
//    }
//}




