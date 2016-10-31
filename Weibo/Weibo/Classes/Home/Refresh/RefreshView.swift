//
//  RefreshView.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/31.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SnapKit

class WHRefreshControl : UIRefreshControl {
    
    override init() {
        super.init()
        
        //添加子控件
        addSubview(refreshView)
        //布局子控件
        refreshView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 150, height: 50))
            make.center.equalTo(self)
        }
        
        //监听UIRefreshControl frame改变
        addObserver(self, forKeyPath: "frame", options:.new, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeObserver(self, forKeyPath: "frame")
    }
    
    ///记录是否需要旋转
    var rotationFlag = false
    
    ///内部控制方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if frame.origin.y == 0 || frame.origin.y == -64 {
            return
        }
        
        //通过观察者发现:往下拉y越小，往上推y越大
        if frame.origin.y < -50 && !rotationFlag {
            rotationFlag = true
            print("往上选装")
            refreshView.rotationArrow(rotationFlag)
            
        }else if frame.origin.y > -50 && rotationFlag {
            rotationFlag = false
            print("往下旋转")
            refreshView.rotationArrow(rotationFlag)
        }
        
    }
    
    ///懒加载
    fileprivate lazy var refreshView : RefreshView = RefreshView.refreshView()
}

class RefreshView: UIView {

    /// 菊花
    @IBOutlet weak var loadingImageView: UIImageView!
    /// 提示视图
    @IBOutlet weak var tipView: UIView!
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    class func refreshView() -> RefreshView {
        return Bundle.main.loadNibNamed("RefreshView", owner: nil, options: nil)?.last as! RefreshView
    }
    
    // MARK: - 外部控制方法
    ///旋转箭头
    func rotationArrow(_ flag : Bool) {
        var angle : CGFloat = flag ? -0.01 : 0.01
        angle += CGFloat(M_PI)
        /*
         transform旋转动画默认是按照顺时针旋转的
         但是旋转还有一个原则，就近原则
         */
        UIView.animate(withDuration: 2.0) {
//            self.arrowImageView.transform = 
        }
        
    }

}
