//
//  BaseViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    var isLogin = false
    
    var touristView : TouristView?
    
    override func loadView() {
        
        return isLogin ? super.loadView() : setupTouristView()
        
    }
    
    func setupTouristView() {
        let otherView = TouristView.TouristView()
        view = otherView
    }

}
