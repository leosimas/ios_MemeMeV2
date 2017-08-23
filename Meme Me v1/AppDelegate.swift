//
//  AppDelegate.swift
//  Meme Me v1
//
//  Created by SoSucesso on 22/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var memes = [Meme]()
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func add(_ meme : Meme) {
        memes.append(meme)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }


}

