//
//  AppDelegate.swift
//  HelloFlickr
//
//  Created by Ranjith Kumar on 7/4/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import FlickrKit

struct FlickrKeys {
    static let ApiKey:String = "46606a4138ae73154f81868e904c1617"
    static let SceretKey:String = "acd3d39e9afb505d"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.flickrSetup()
        return true
    }
    
    private func flickrSetup() {
        FlickrKit.shared().initialize(withAPIKey: FlickrKeys.ApiKey, sharedSecret: FlickrKeys.SceretKey)
    }

}

