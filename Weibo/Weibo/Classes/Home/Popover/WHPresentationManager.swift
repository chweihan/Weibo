//
//  WHPresentationManager.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/17.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

//自定义转场的展现
let WHPresentationManagerDidPresented = "WHPresentationManagerDidPresented"
//自定义转场的消失
let WHPresentationManagerDidDismissed = "WHPresentationManagerDidDismissed"

class WHPresentationManager: NSObject ,UIViewControllerTransitioningDelegate ,UIViewControllerAnimatedTransitioning{
    
    //定义标记记录当前是否是展现
    private var isPresent = false

    //保存菜单的尺寸
    var presentedFrame = CGRect.zero

    // MARK: - UIViewControllerTransitioningDelegate
    //该方法在于返回一个负责转场动画的对象
    //可以在对象中控制弹出视图的尺寸等
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let pc = WHPresentationController(presentedViewController: presented, presenting: presenting)
        pc.presentedFrame = presentedFrame
        return pc
    }
    
    //该方法用于返回一个负责转场如何出现的对象
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        NotificationCenter.default.post(name: NSNotification.Name(WHPresentationManagerDidPresented), object: nil)
        return self
    }
    
    //该方法用于返回一个负责转场如何消失的对象
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        NotificationCenter.default.post(name: Notification.Name(WHPresentationManagerDidDismissed), object: nil)
        return self
    }
    
    // MARK: - UIPresentationController
    //告诉系统展示和消失的动画时长
    //暂时用不上
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    
    //专门用于管理modal如何展现和消失的,无论是展现还是消失都会调用该方法
    //注意点：只要我们实现了这个代理方法,那么系统就不会再有默认的动画了
    //也就是说默认的modal从上至下的移动系统都不会在帮我们添加了,所有的动画操作都需要我们自己实现，包括需要展现的视图也需要我们自己添加到容器上
    //transitionContext 所有动画需要的东西都要保存到上线文中,换而言之就是可以通过transitionContext获取我们想要的东西
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //判断当前是展示还是消失
        if isPresent {
            //展示
            willPresentedController(using: transitionContext)
        }else {
            //消失
            willDismissedController(using: transitionContext)
        }
    }
    
    private func willPresentedController(using transitionContext: UIViewControllerContextTransitioning) {
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

    }
    
    private func willDismissedController(using transitionContext: UIViewControllerContextTransitioning) {
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
