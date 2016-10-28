//
//  StatusViewModel.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/26.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    
    /// 模型对象
    var status : Status
    
    init(_ status : Status) {
        self.status = status
        
        // 处理头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        
        // 处理会员图标
        if (status.user?.mbrank)! >= 1 && (status.user?.mbrank)! <= 6 {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        
        // 处理认证图片
        switch status.user?.verified_type ?? -1 {
            case 0:
                verified_image = UIImage(named: "avatar_vip")
                break
            case 2, 3, 5:
                verified_image = UIImage(named: "avatar_enterprise_vip")
                break
            case 220:
                verified_image = UIImage(named: "avatar_grassroot")
                break
            default:
                verified_image = nil
        }
        
        // 处理来源
        if let sourceStr : String = status.source, sourceStr != "" {
            let startIndex = (sourceStr as NSString).range(of: ">").location + 1
            let length = (sourceStr as NSString).range(of: "<").location - startIndex
            let result = (sourceStr as NSString).substring(with: NSRange(location : startIndex, length:length))
            source_Text = "来自" + result
        }
        
        // 处理时间
        if let timeStr = status.created_at, timeStr != "" {
            //将服务器返回的时间格式化成Date
            let createDate = Date.createDate(timeStr, "EE MM dd HH:mm:ss Z yyyy")
            //生成发布微博时间对应的字符串
            created_Time = createDate.descriptionStr()
        }
        
        // 处理配图url
        // 从模型中取出配图数组
//        if let picurls = status.pic_urls
        if let picurls = (status.retweeted_status != nil) ? status.retweeted_status?.pic_urls :status.pic_urls {
            thumbnail_pic = [NSURL]()
            //遍历配图数组下载图片
            for dict in picurls {
                //取出图片的url字符串
                guard let urlStr = dict["thumbnail_pic"] as? String else {
                    continue
                }
                let url = NSURL(string: urlStr)!
                thumbnail_pic?.append(url)
            }
        }
        
        //处理转发
        if let text = status.retweeted_status?.text {
            let name = status.retweeted_status?.user?.screen_name ?? ""
            forwardText = "@" + name + ":" + text
        }
        
    }
    
    /// 用户认证图片
    var verified_image : UIImage?
    
    /// 会员图片
    var mbrankImage : UIImage?
    
    /// 用户头像URL地址
    var icon_URL : NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time : String = ""
    
    /// 微博格式化之后的来源
    var source_Text : String = ""
    
    /// 保存所有配图URL
    var thumbnail_pic : [NSURL]?
    
    /// 转发微博格式化之后正文
    var forwardText : String?
}
