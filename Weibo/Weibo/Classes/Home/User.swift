//
//  User.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/25.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class User: NSObject {
    ///用户id
    var idstr : String?
    ///用户昵称
    var screen_name : String?
    ///用户头像地址（中图），50×50像素
    var profile_image_url : String?
    ///用户认证类型 -1 没有认证 ， 0 普通认证 ，2 3 5 企业认证， 220 达人
    var verified_type : Int = -1
    ///会员等级，取值范围1-6
    var mbrank : Int = -1
    
    init(_ dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["idstr", "screen_name", "profile_image_url", "verified_type","mbrank"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
