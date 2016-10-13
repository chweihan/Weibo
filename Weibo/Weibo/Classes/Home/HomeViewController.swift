//
//  HomeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            touristView?.setupTouristViewInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        setupNav()
    }
    
    private func setupNav() {
        //设置左右两边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem("navigationbar_friendattention", self, #selector(self.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem("navigationbar_pop", self, #selector(self.rightBtnClick))
        //设置标题
        let titleButton = TitleButton()
        titleButton.setTitle("cweihan", for: .normal)
        titleButton.addTarget(self, action: #selector(self.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    
    func titleBtnClick(titleBtn : TitleButton) {
       
        //修改按钮状态
        titleBtn.isSelected = !titleBtn.isSelected
        
        //显示菜单,创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else {
            return
        }
        
        menuView.transitioningDelegate = self
        menuView.modalPresentationStyle = .custom
        
        present(menuView, animated: true, completion: nil)
    }
    
    func leftBtnClick() {
        print("leftBtnClick")
    }
    
    func rightBtnClick() {
        print("rightBtnClick")
    }

    //定义标记记录当前是否是展现
    var isPresent = false
}


extension HomeViewController : UIViewControllerTransitioningDelegate {
    
    //该方法在于返回一个负责转场动画的对象
    //可以在对象中控制弹出视图的尺寸等
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return WHPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    //该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    //该方法用于返回一个负责转场如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        return self
    }
}

extension HomeViewController : UIViewControllerAnimatedTransitioning {
    
    //告诉系统展示和消失的动画时长
    //暂时用不上
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
  
    //专门用于管理modal如何展现和消失的,无论是展现还是消失都会调用该方法
    //注意点：只要我们实现了这个代理方法,那么系统就不会再有默认的动画了
    //也就是说默认的modal从上至下的移动系统都不会在帮我们添加了,所有的动画操作都需要我们自己实现，包括需要展现的视图也需要我们自己添加到容器上
    //transitionContext 所有动画需要的东西都要保存到上线文中,换而言之就是可以通过transitionContext获取我们想要的东西
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //判断当前是展示还是消失
        if isPresent {
            //展示
            //通过ToViewKey取出的就是toVc对应的view
            guard let toView = transitionContext.view(forKey: .to) else {
                return
            }
            //将需要弹出的视图添加到containerView上
            transitionContext.containerView.addSubview(toView)
            //执行动画
            toView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
            //设置锚点
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
                toView.transform = CGAffineTransform.identity
                }, completion: { (_) in
                    //注意,自定义转场动画，在执行完东爱护之后一定要告诉系统动画执行完毕
                    transitionContext.completeTransition(true)
            })
            
        }else {
            //消失
            //拿到需要消失的视图
            guard let fromView = transitionContext.view(forKey: .from) else {
                return
            }
            
            //执行动画让视图消失
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
                //突然消失的原因：CGFloat不准确,导致无法执行动画,遇到这样的问题只需要将CGFloat的值设置为一个很小的值即可
                fromView.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
            })
            
        }
    }
    
}



