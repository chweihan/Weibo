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
//        window = UIWindow(frame: UIScreen.main.bounds)
//        //设置window
//        window?.backgroundColor = UIColor.white
//        window?.rootViewController = MainViewController()
//        //显示window
//        window?.makeKeyAndVisible()
        
//        App Key：3090663153
//        App Secret：6ab4bbc298a13dc13a39360a4ff8f6ed
//        OAuth: https://api.weibo.com/oauth2/authorize?client_id=3090663153&redirect_uri=http://www.baidu.com
//        https://www.baidu.com/?code=56a50941f4958461c0b188d31dc524bf
        
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        return true
    }

    

}

