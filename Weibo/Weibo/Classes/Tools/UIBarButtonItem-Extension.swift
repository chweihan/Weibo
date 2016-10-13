//
//  UIBarButtonItem-Extension.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/13.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(_ imageName : String ,_ target: AnyObject?,_ action: Selector) {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        self.init(customView: btn)
        
    }
    

}
