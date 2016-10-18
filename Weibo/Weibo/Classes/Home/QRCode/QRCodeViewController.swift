//
//  QRCodeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/17.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController {

    @IBOutlet weak var customTabBar: UITabBar!
    //容器高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    //冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    //冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customTabBar.selectedItem = customTabBar.items?.first
        
        //设置tabBar代理
        customTabBar.delegate = self
        
        //开始扫描二维码
        scanQRcode()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
    
    func startAnimation() {
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 2.0) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - 内部控制方法
    private func scanQRcode() {
        //判断输入能否添加到会话中
        if !session.canAddInput(input) {
            return
        }
        
        //判断输出能够添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        
        //添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        //设置输出能够解析的数据类型
        //注意点:设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        //设置监听 监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //添加预览图层
        view.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = view.bounds
        
        //开始扫描
        session.startRunning()
        
    }
    
    
    //关闭按钮
    @IBAction func backBtnClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    //相册按钮
    @IBAction func albumBtnClick(_ sender: AnyObject) {
    }
    
    // MARK: - 懒加载
    //输入对象
    private lazy var input : AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    //会话
    private lazy var session : AVCaptureSession = AVCaptureSession()
    
    //输出对象
    private lazy var output : AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
    //预览图层
    private lazy var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
}

extension QRCodeViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        //根据当前的按钮调整二维码容器的高度
        containerHeightCons.constant = item.tag == 0 ? 204 : 102
        view.layoutIfNeeded()
        
        //移除动画
        scanLineView.layer.removeAllAnimations()
        
        //重新开始动画
        startAnimation()
        
        
    }
}

extension QRCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    ///只要扫描到结果就会调用
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        print(metadataObjects.last)
    }
}


