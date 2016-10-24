//
//  NetworkTool.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/18.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import  AFNetworking

enum WHRequestType {
    case Get
    case Post
}

class NetworkTool: AFHTTPSessionManager {
    
    //swift推荐我们这边编写单例
    static let shareInstance : NetworkTool = {
        
//        let baseURL = NSURL(string: "https://api.weibo.com/")!
        
//        let instance = NetworkTool(baseURL: baseURL as URL, sessionConfiguration: URLSessionConfiguration.default)
        let instance = NetworkTool()
        
//        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set

        
        return instance
    }()
    
    //将成功和失败的回调写在一个逃逸闭包中
//    func request(requestType : WHRequestType, url : String , parameters : [String : Any], resultBlock : @escaping([String : Any]?, Error?) -> ()) {
//    
//        //成功闭包
//        let successBlock = {(task : URLSessionDataTask)}
//        
//        
//    }
//    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
