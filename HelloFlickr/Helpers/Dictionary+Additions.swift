//
//  Dictionary+Additions.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 2/3/18.
//  Copyright © 2018 Ranjith Kumar. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(string key: Key) -> String? {
        get {
            return self[key] as? String
        }
    }
    subscript(json key: Key) -> [String:Any]? {
        get {
            return self[key] as? [String:Any]
        }
    }
    subscript(double key: Key) -> Double? {
        get {
            return self[key] as? Double
        }
    }
    subscript(int key: Key) -> Int? {
        get {
            return self[key] as? Int
        }
    }

}
