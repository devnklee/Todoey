//
//  AppDelegate.swift
//  Todoey
//
//  Created by kibeom lee on 2018. 1. 20..
//  Copyright © 2018년 kibeom lee. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do {
            _ = try Realm()
        }catch {
            print("error happend while init realm")
        }
        
        return true
    }

    
}

