//
//  String+Extension.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/20.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

extension String {
    /// 快速生成缓存路径
    func cachesDir() -> String {
        //1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory , FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2生成缓存路劲
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    /// 快速生成文档路径
    func docDir() -> String {
        //1.获取缓存目录的路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory , FileManager.SearchPathDomainMask.userDomainMask, true).last!
        //2生成缓存路劲
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    ///快速生成临时路径
    func tmpDir() -> String {
        //1.获取缓存目录的路径
        let path = NSTemporaryDirectory()
        //2生成缓存路劲
        let name = (self as NSString).lastPathComponent
        let filePath = (path as NSString).appendingPathComponent(name)
        
        return filePath
    }
    
    
}
