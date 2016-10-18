//
//  HomeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            touristView?.setupTouristViewInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //添加导航栏视图
        setupNav()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.titleChange), name: NSNotification.Name(rawValue: WHPresentationManagerDidPresented), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.titleChange), name: NSNotification.Name(rawValue: WHPresentationManagerDidDismissed), object: nil)
    }
    
    //按钮点击事件
    func titleChange() {
        //修改按钮状态
        titleButton.isSelected = !titleButton.isSelected
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNav() {
        //设置左右两边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem("navigationbar_friendattention", self, #selector(self.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem("navigationbar_pop", self, #selector(self.rightBtnClick))
        
        //设置标题
        navigationItem.titleView = titleButton
    }
    
    func titleBtnClick(titleBtn : TitleButton) {
       
        
        //显示菜单,创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        menuView.transitioningDelegate = presentationManager
        menuView.modalPresentationStyle = .custom
        
        present(menuView, animated: true, completion: nil)
    }
    
    func leftBtnClick() {
        print("leftBtnClick")
    }
    
    func rightBtnClick() {
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var presentationManager : WHPresentationManager = {
        let manager = WHPresentationManager()
        manager.presentedFrame = CGRect(x: 100, y: 45, width: 200, height: 200)
        return manager
    }()
    
    private lazy var titleButton : UIButton = {
        //设置标题
        let btn = TitleButton()
        btn.setTitle("cweihan", for: .normal)
        btn.addTarget(self, action: #selector(self.titleBtnClick(titleBtn:)), for: .touchUpInside)
        return btn
    }()
}





