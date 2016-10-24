//
//  BaseViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    var isLogin = UserAccount.isLogin()
    
    var touristView : TouristView?
    
    override func loadView() {
        
        return isLogin ? super.loadView() : setupTouristView()
        
    }
    
    func setupTouristView() {
        touristView = TouristView.TouristView()
        view = touristView
        
//        touristView?.delegate = self
        
        touristView?.registerButton .addTarget(self, action: #selector(self.registerBtnClick), for: .touchUpInside)
        touristView?.loginButton .addTarget(self, action: #selector(self.loginBtnClick), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .plain, target: self, action: #selector(self.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .plain, target: self, action: #selector(self.loginBtnClick))
    }
    
    func registerBtnClick() {
        print("registerBtnClick")
    }

    
    func loginBtnClick() {
        print("loginBtnClick")
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
    }
}

//extension BaseViewController : TouristViewDelegate {
//    func touristViewDidRegisterBtnClick(touristView : TouristView) {
//        print(".")
//    }
//    
//    func touristViewDidLoginBtnClick(touristView : TouristView) {
//        print(".")
//    }
//}
