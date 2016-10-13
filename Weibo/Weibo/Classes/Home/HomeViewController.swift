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
    }

}
