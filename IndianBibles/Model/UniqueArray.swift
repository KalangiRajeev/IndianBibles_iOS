//
//  UniqueArray.swift
//  IndianBibles
//
//  Created by Admin on 26/04/21.
//  Copyright © 2021 Rajeev Kalangi. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
