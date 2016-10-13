//
//  TouristView.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

//protocol TouristViewDelegate : NSObjectProtocol{
//    func touristViewDidRegisterBtnClick(touristView : TouristView)
//    func touristViewDidLoginBtnClick(touristView : TouristView)
//}

class TouristView: UIView {
    
    //转盘
    @IBOutlet weak var rotationImageView: UIImageView!
    //图标
    @IBOutlet weak var iconImageView: UIImageView!
    //文本
    @IBOutlet weak var titleLabel: UILabel!
    //注册按钮
    @IBOutlet weak var registerButton: UIButton!
    //登录按钮
    @IBOutlet weak var loginButton: UIButton!
    
//    weak var delegate : TouristViewDelegate?
    
    
    func setupTouristViewInfo(imageName : String? , title : String) {
        titleLabel.text = title
        guard let name = imageName else {
            
            setupRotataionAnim()
            
            //首页
            return
        }
        //不是首页
        rotationImageView.isHidden = true
        iconImageView.image = UIImage(named: name)
    }
    
    
    //转盘动画
    func setupRotataionAnim() {
        //创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        //设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        //注意：默认情况下只要视图小时，系统就会自动移除动画
        //只要设置isRemovedOnCompletion为false，系统就不会移除动画
        anim.isRemovedOnCompletion = false
        //将动画添加到图层上
        rotationImageView.layer.add(anim, forKey: nil)
    }
    
    
    class func TouristView() -> TouristView {
        return Bundle.main.loadNibNamed("TouristView", owner: nil, options: nil)?.last as! TouristView
    }
    
//    @IBAction func registerBtnClick(_ sender: AnyObject) {
//        delegate?.touristViewDidRegisterBtnClick(touristView: self)
//    }
//
//    @IBAction func loginBtnClick(_ sender: AnyObject) {
//        delegate?.touristViewDidLoginBtnClick(touristView: self)
//    }
    
    

}
