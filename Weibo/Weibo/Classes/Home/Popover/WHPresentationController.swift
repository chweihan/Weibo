//
//  WHPresentationController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/13.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class WHPresentationController: UIPresentationController {
    
    /*
     1.如果不自定义专场model出来的控制器会移除原来所有的控制器
     2.如果自动以的转场model出来的控制器不会移除原来的控制器
     3.如果不自定义转场model出来的控制器的尺寸和屏幕一样
     4.如果自定义转场model出来的控制器的尺寸我们可以在containerViewWillLayoutSubviews方法中控制
     5.containerView非常重要，容器视图，所有model出来的视图都是天价到cantainerView上的
     6.presentView()非常重要,通过该方法能够拿到弹出来的视图     
     */
    
    var presentedFrame = CGRect.zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    //用于布局专场动画弹出来的控件
    override func containerViewWillLayoutSubviews() {
        //设置弹出视图的尺寸
        presentedView?.frame = presentedFrame  //CGRect(x: 100, y: 45, width: 200, height: 200)
        //添加蒙版
        containerView?.insertSubview(coverButton, at: 0)
        coverButton.addTarget(self, action: #selector(self.coverBtnClick), for: .touchUpInside)
    }
    
    // MARK: - 内部控制方法
    func coverBtnClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - 懒加载
    private lazy var coverButton : UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.main.bounds
        btn.backgroundColor = UIColor.clear
        return btn
    }()
    
    
}
