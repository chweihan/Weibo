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
    
    var viewModel : StatusViewModel? {
        didSet{
            //设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL as URL!, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            
            //设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            
            //设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            
             //设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let vipImage = viewModel?.mbrankImage {
                vipImageView.image = vipImage
                nameLabel.textColor = UIColor.orange
            }
            
            //设置时间 Tue Oct 25 15:53:46 +0800 2016
            timeLabel.text = viewModel?.created_Time
            
            //设置来源
            sourceLabel.text = viewModel?.source_Text
            //设置正文
            contentLabel.text = viewModel?.status.text
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2 * 10
    }
    
    

}
