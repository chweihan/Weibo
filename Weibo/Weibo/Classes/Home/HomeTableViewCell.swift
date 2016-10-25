//
//  HomeTableViewCell.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/25.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    
    var status : Status? {
        didSet{
            //设置头像
            if let urlStr = status?.user?.profile_image_url {
                let url = NSURL(string: urlStr)
                iconImageView.sd_setImage(with: url as URL!, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            }
            //设置认证图标
            if let type = status?.user?.verified_type {
                var name = ""
                switch type {
                case 0:
                    name = "avatar_vip"
                    break
                case 2,3,5:
                    name = "avatar_enterprise_vip"
                    break
                case 220:
                    name = "avatar_grassroot"
                    break
                default:
                    name = ""
                }
                
                verifiedImageView.image = UIImage(named: name)
            }
            
            //设置昵称
            nameLabel.text = status?.user?.screen_name
            //设置会员图标
            if let rank = status?.user?.mbrank {
                if rank >= 1 && rank <= 6 {
                    vipImageView.image = UIImage(named: "common_icon_membership_level\(rank)")
                    nameLabel.textColor = UIColor.orange
                }else {
                    vipImageView.image = nil
                    nameLabel.textColor = UIColor.black
                }
            }
            
            //设置时间 Tue Oct 25 15:53:46 +0800 2016
            timeLabel.text = "刚刚" //status?.create_at
            if let timeStr = status?.created_at {
                //将服务器返回的时间格式转化为NSDate
                let formatter = DateFormatter()
                formatter.dateFormat = "EE MM dd HH:mm:ss Z yyyy"
                //如果不指定一下代码,在真机中可能无法转换
                formatter.locale = NSLocale(localeIdentifier: "en") as Locale!
                let createDate = formatter.date(from: timeStr)!
                
                //创建一个日期类
                let calendar = NSCalendar.current
                /*
                // 该方法可以获取指定时间的组成成分 |
                let comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: createDate)
                print(comps.year)
                print(comps.month)
                print(comps.day)
                */
                var result = ""
                var formatterStr = "HH:mm"
                if calendar.isDateInToday(createDate) {
                    //今天
                    //比较两个时间之间的差值
                    let interval = Int(Date.init().timeIntervalSince(createDate))
                    
                    if interval < 60 {
                        result = "刚刚"
                    }else if interval < 60 * 60 {
                        result = "\(interval / 60)分钟前"
                    }else if interval < 60 * 60 * 24 {
                        result = "\(interval / (60 * 60))小时前"
                    }
                }else if calendar.isDateInYesterday(createDate) {
                    //昨天
                    formatterStr = "昨天" + formatterStr
                    formatter.dateFormat = formatterStr
                    result = formatter.string(from: createDate)
                }else {
                    //该方法可以获取两个时间之间的差值
                    let comps = calendar.dateComponents([Calendar.Component.year], from: createDate, to: Date.init())
                    if comps.year! >= 1 {
                        //更早的时间
                        formatterStr = "yyyy-MM-dd" + formatterStr
                    }else {
                        //一年以内
                        formatterStr = "MM-dd" + formatterStr
                    }
                    formatter.dateFormat = formatterStr
                    result = formatter.string(from: createDate)
                }
                
                timeLabel.text = result
            }
            
            //设置来源
            if let source : NSString = status?.source as NSString? , source != ""{
                let start = (source as NSString).range(of: ">").location + 1
                let length = (source as NSString).range(of: "</").location - start
                let sourceStr = (source as NSString).substring(with: NSRange(location : start, length:length))
                sourceLabel.text = "来自" + sourceStr
            }
            //设置正文
            contentLabel.text = status?.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2 * 10
    }
    
    

}
