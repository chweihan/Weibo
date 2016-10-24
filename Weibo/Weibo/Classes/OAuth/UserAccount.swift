//
//  UserAccount.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/19.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class UserAccount: NSObject , NSCoding{
    /// 令牌
    var access_token: String?
    /// 从授权那一刻开始, 多少秒之后过期时间
    var expires_in: Int = 0
        {
        didSet {
            /// 生成正在过期时间
            expires_Date = NSDate(timeIntervalSinceNow: TimeInterval(expires_in))
        }
    }
    
    /// 真正的过期时间
    var expires_Date : NSDate?
    /// 用户id
    var uid: String?
    /// 用户头像地址(大图)180*180
    var avatar_large : String?
    
    /// 用户昵称
    var screen_name : String?
    
    
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject]) {
        super.init()
        //如果要想初始化方法使用KVC必须先调用super.init初始化对象
        //如果属性是基本数据类型，那么建议不要使用可选类型，以为基本类型的可选类型在super.init()方法中不会分配内存空间
        self.setValuesForKeys(dict)
//        self.access_token = dict["access_token"] as! String?
//        self.expires_in = dict["expires_in"] as! Int
//        self.uid = dict["uid"] as! String?
//        self.expires_data = dict["expires_data"] as! NSDate?
    }
    
    //当kvc发现没有对应的key是就会调用
//    override func setValue(_ value: Any?, forKey key: String) {
//        
//    }
    //当kvc发现没有对应的key是就会调用
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid","expires_data"]
        let dict = dictionaryWithValues(forKeys: property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    //回归模型
    func saveAccount() -> Bool {
        //3 归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)

    }
    
    /// 定义属性保存授权模型
    static var account : UserAccount?
    
    /// 定义属性保存授权模型
    static let filePath : String = "userAccount".cachesDir()
    
    //获取用户信息
    func loadUserInfo(finished: @escaping (_ account: UserAccount? , _ error: NSError?) -> ()) {
        //断言
        //断言account_token一定是不等于nil的，如果运行时account_token等于nil，那么程序就会崩溃，并报错
        assert(access_token != nil, "使用该方法必须先授权")
        
        //准备请求轮径
        let path = "https://api.weibo.com/2/users/show.json"
        //准备请求参数
        let params = ["access_token" : access_token! , "uid" : uid!]
        
        NetworkTool.shareInstance.get(path, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObj: Any?) in
            let dict = responseObj as! [String : Any]
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            finished(self, nil)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                finished(nil, error as NSError?)
        })
        
    }
    
    
    //解归档模型
    class func loadUserAccount() -> UserAccount? {
        //判断是否加载过
        if UserAccount.account != nil {
            print("已经加载过了")
            //直接返回
            return UserAccount.account
        }
        
        //尝试从文件中加载
        print("还没加载过")
        
        //3 解归档对象
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: UserAccount.filePath) as? UserAccount else {
            return nil
        }
        
        //校验是否过期
        guard let date = account.expires_Date else {
            return nil
        }
        
        if date.compare(NSDate() as Date) == ComparisonResult.orderedAscending {
            return nil
        }
        
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    /// 判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_Date, forKey: "expires_Date")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in")
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.expires_Date = aDecoder.decodeObject(forKey: "expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObject(forKey:"avatar_large") as? String
        self.screen_name = aDecoder.decodeObject(forKey:"screen_name") as? String
    }
    
}


