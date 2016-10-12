//
//  UIButton-Extension.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(_ imageName : String , _ backgroundImageName : String) {
        
        self.init()
        
        //设置按钮前景图片
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        //设置按钮背景图片
        setBackgroundImage(UIImage(named: backgroundImageName), for: .normal)
        setBackgroundImage(UIImage(named: backgroundImageName + "_highlighted"), for: .highlighted)
        
        //设置按钮尺寸
        sizeToFit()

    }
    
}
