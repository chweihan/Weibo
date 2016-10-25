//
//  NetworkTool.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/18.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import  AFNetworking

class NetworkTool: AFHTTPSessionManager {
    
    //swift推荐我们这边编写单例
    static let shareInstance : NetworkTool = {
        let instance = NetworkTool()
        instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set

        return instance
    }()
    
    // MARK: - 外部控制方法
    func loadStatuses(finished : @escaping (_ array : [[String : Any]]?, _ error: NSError?) -> ()) {
        assert(UserAccount.loadUserAccount() != nil, "必须")
        //准备路径
        let path = "https://api.weibo.com/2/statuses/home_timeline.json"
        //准备参数
        let params = ["access_token" : (UserAccount.loadUserAccount()?.access_token!)! as String]
 
        get(path, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObj: Any?) in
            
            //返回数据给调用者
            guard let arr = (responseObj as! [String : Any])["statuses"] as? [[String : Any]] else {
                finished(nil,NSError(domain: "com.baidu.cwh", code: 10000, userInfo:["message":"没有获取到数据"]))
                return
            }
            
            finished(arr, nil)
    
            }) { (task: URLSessionDataTask?, error: Error) in
                
                finished(nil, error as NSError?)
        }
        
    }
    
    
}
