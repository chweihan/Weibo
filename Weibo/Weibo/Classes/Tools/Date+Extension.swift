//
//  Date+Extension.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/25.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

extension Date {
    
    /// 根据一个字符串创建一个NSDate
    static func createDate(_ timeStr: String, _ formatterStr: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = formatterStr
        //如果不指定以下代码，在真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        return formatter.date(from: timeStr)!
    }
    
    
    /// 生成当前时间对应的字符串
    func descriptionStr() -> String {
        //创建时间格式化对象
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
        //创建一个日历类
        let calendar = Calendar.current
        //定义变量记录时间格式
        var formatterStr = "HH:mm"
        //判断是否是今天
        if calendar.isDateInToday(self) {
            //今天
            //比较两个时间之间的差值
            let interval = Int(Date.init().timeIntervalSince(self))
            
            if interval < 60 {
                return "刚刚"
            }else if interval < 60 * 60 {
                return "\(interval / 60)分钟前"
            }else if interval < 60 * 60 * 24 {
                return "\(interval / (60 * 60))小时前"
            }
        }else if calendar.isDateInYesterday(self) {
            //昨天
            formatterStr = "昨天" + formatterStr
        }else {
            //该方法可以获取两个时间之间的差值
            let comps = calendar.dateComponents([Calendar.Component.year], from: self, to: Date.init())
            if comps.year! >= 1 {
                //更早时间
                formatterStr = "yyyy-MM-dd" + formatterStr
            }else {
                //一年以内
                formatterStr = "MM-dd" + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.string(from: self)
    }
}
