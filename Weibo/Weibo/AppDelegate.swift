//
//  AppDelegate.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/8.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        //设置window
        window?.backgroundColor = UIColor.white
        window?.rootViewController = MainViewController()
        //显示window
        window?.makeKeyAndVisible()
        
        return true
    }

    

}

