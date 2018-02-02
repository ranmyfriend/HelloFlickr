//
//  Photo.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/5/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import Foundation

class Photo {
    var title,id,description,uploaded_on:String?
    var geo_latitude,geo_longitude:String?
    var url:URL?
    var dictionary:[String:Any]?
    var place:Place?
    var selected:Bool?
    var views:String?
    convenience init(inputDictionary: Dictionary<String,Any>) {
        self.init()
        self.dictionary = inputDictionary
        if let title = inputDictionary[string:"title"] {
            self.title =  title
        }
        if let id = inputDictionary[string:"id"] {
            self.id = id
        }
        if let views = inputDictionary[string:"views"] {
            self.views = views
        }
        
        if let description = inputDictionary[json:"description"] {
            self.description = description[string:"_content"]!
        }
        
        if let uploaded_on = inputDictionary[string:"dateupload"] {
            self.uploaded_on = uploaded_on
        }
        
        self.geo_latitude = inputDictionary["latitude"] as? String
        self.geo_longitude = inputDictionary["longitude"] as? String
        
        if let url = inputDictionary["url"] {
            self.url = url as? URL
        }
    }
}
