//
//  TouristView.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class TouristView: UIView {

    class func TouristView() -> TouristView {
        return Bundle.main.loadNibNamed("TouristView", owner: nil, options: nil)?.last as! TouristView
    }

}
