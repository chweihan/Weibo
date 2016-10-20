//
//  UserAccount.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/19.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class UserAccount: NSObject , NSCoding{
    
    var access_token: String?
    var expires_in: Int = 0
    var uid: String?
    
    // MARK: - 生命周期方法
    init(dict : [String : AnyObject]) {
        super.init()
        //如果要想初始化方法使用KVC必须先调用super.init初始化对象
        //如果属性是基本数据类型，那么建议不要使用可选类型，以为基本类型的可选类型在super.init()方法中不会分配内存空间
        self.setValuesForKeys(dict)
    }
    
    //当kvc发现没有对应的key是就会调用
    override func setValue(_ value: Any?, forKey key: String) {
        
    }
    override var description: String {
        return "qqq"
    }
    
    // MARK: - 外部控制方法
    //回归模型
    func saveAccount() -> Bool {
        
        //1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory , FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2生成缓存路劲
        let filePath = (path as NSString).appendingPathComponent("userAccount.plist")
        
        print(filePath)
        
        //3 归档对象
        return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)

    }
    
    /// 定义属性保存授权模型
    static var account : UserAccount?
    
    class func loadUserAccount() -> UserAccount? {
        //判断是否加载过
        if UserAccount.account != nil {
            print("已经加载过了")
            //直接返回
            return UserAccount.account
        }
        
        //尝试从文件中加载
        print("还没加载过")
        
        //1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory , FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2生成缓存路劲
        let filePath = (path as NSString).appendingPathComponent("userAccount.plist")
        
        //3 解归档对象
        guard let account = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? UserAccount else {
            return UserAccount.account
        }
        
        UserAccount.account = account
        
        return UserAccount.account
    }
    
    
    // MARK: - NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(expires_in, forKey: "expires_in")
        aCoder.encode(uid, forKey: "uid")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        self.expires_in = aDecoder.decodeInteger(forKey: "expires_in")
        self.uid = aDecoder.decodeObject(forKey: "uid") as? String
    }
    
}


