//
//  WelcomeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/20.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    //标题
    @IBOutlet weak var textLabel: UILabel!
    //头像容器
    @IBOutlet weak var iconImageView: UIImageView!
    //头像底部约束
    @IBOutlet weak var iconBottomCons: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        iconImageView.layer.cornerRadius = 45
        iconImageView.clipsToBounds = true
        
        assert(UserAccount.loadUserAccount() != nil,"必须授权之后才能显示欢迎界面")
        
        //设置头像
        guard let url = NSURL(string: (UserAccount.loadUserAccount()?.avatar_large!)!) else {
            return
        }
        iconImageView.sd_setImage(with: url as URL!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //让头像执行动画
        iconBottomCons.constant = (UIScreen.main.bounds.height - iconBottomCons.constant)
        
        UIView.animate(withDuration: 2.0, animations: { 
            self.view.layoutIfNeeded()
            }) { (_) in
                
                UIView.animate(withDuration: 2.0, animations: { 
                    self.textLabel.alpha = 1.0
                    }, completion: { (_) in
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WHSwitchRootViewController), object: true)
                })
                
        }
        
    }

    

}
