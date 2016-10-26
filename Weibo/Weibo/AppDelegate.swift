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
        
        
        
//        App Key：3090663153
//        App Secret：6ab4bbc298a13dc13a39360a4ff8f6ed
//        OAuth: https://api.weibo.com/oauth2/authorize?client_id=3090663153&redirect_uri=http://www.baidu.com
//        https://www.baidu.com/?code=56a50941f4958461c0b188d31dc524bf
        
        //设置外观
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        
        //注册监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeRootViewController(notice:)), name: NSNotification.Name(rawValue: WHSwitchRootViewController), object: nil)
        
        //创建window
        window = UIWindow(frame: UIScreen.main.bounds)
        //设置window
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = defaulthViewController()
        //显示window
        window?.makeKeyAndVisible()
        
        print(isNewVersion())
        
        return true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AppDelegate {
    
    @objc fileprivate func changeRootViewController(notice : Notification) {
        if notice.object as! Bool {
            window?.rootViewController = R.storyboard.main.instantiateInitialViewController()!
        }else {
            window?.rootViewController = R.storyboard.welcome.instantiateInitialViewController()!
        }
        
    }
    
    fileprivate func defaulthViewController() -> UIViewController {
        //判断是否登录
        if UserAccount.isLogin() {
            //判断是否有新版本
            if isNewVersion() {
                return R.storyboard.newFeature.instantiateInitialViewController()!
            }else {
                return R.storyboard.welcome.instantiateInitialViewController()!
            }
        }
        //没有登录
        return R.storyboard.main.instantiateInitialViewController()!
    }
    
    fileprivate func isNewVersion() -> Bool{
        //加载info 获取当前版本号
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //获取以前的版本号
        let defaults = UserDefaults.standard
        let sanboxVersion = (defaults.object(forKey: "cwh") as? String) ?? "0.0"
        if currentVersion.compare(sanboxVersion) == ComparisonResult.orderedDescending {
            //当前的版本大于以前的版本
            print("有新版本")
            //如果有新版本，就利用新版本的版本号更新本地的版本号
            defaults.set(currentVersion, forKey: "cwh")
            defaults.synchronize()//ios7以前要写 ios7以后不用写
            return true
        }
        print("没有新版本")
        return false
    }
    
}

