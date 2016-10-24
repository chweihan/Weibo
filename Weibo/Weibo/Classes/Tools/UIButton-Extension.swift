//
//  UIButton-Extension.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(_ imageName : String? , _ backgroundImageName : String?) {
        
        self.init()
        
        if let name = imageName {
            //设置按钮前景图片
            setImage(UIImage(named: name), for: .normal)
            setImage(UIImage(named: name + "_highlighted"), for: .highlighted)

        }
        
        if let backgroundName = backgroundImageName {
            //设置按钮背景图片
            setBackgroundImage(UIImage(named: backgroundName), for: .normal)
            setBackgroundImage(UIImage(named: backgroundName + "_highlighted"), for: .highlighted)
        }
        
        //设置按钮尺寸
        sizeToFit()

    }
    
}
