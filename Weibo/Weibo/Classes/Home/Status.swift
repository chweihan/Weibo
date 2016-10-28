//
//  Status.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/24.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class Status: NSObject {
    ///微博创建时间
    var created_at : String?
    ///字符串型的微博id
    var idstr : String?
    ///微博信息
    var text : String?
    ///微博来源
    var source : String?
    ///用户
    var user : User?
    ///图片数组
    var pic_urls : [[String : Any]]?
    ///转发微博
    var retweeted_status : Status?
    
    
    init(_ dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    //kvc的setValuesForKeys的内部会调用setValue
    override func setValue(_ value: Any?, forKey key: String) {
        //拦截user赋值操作
        if key == "user" {
            user = User(value as! [String : Any])
            return
        }
        
        if key == "retweeted_status" {
            retweeted_status = Status(value as! [String : Any])
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let property = ["created_at", "idstr", "text", "source","user","retweeted_status"]
        let dict = dictionaryWithValues(forKeys: property)
        return "\(dict)"
    }
}
