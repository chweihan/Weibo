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

    //描述
    @IBOutlet weak var textLabel: UILabel!
    
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
    lazy var previewLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    //专门用于保存描边的图层
    lazy var containerLayer : CALayer = CALayer()
    
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
        
//        Optional(<AVMetadataMachineReadableCodeObject: 0x174039420, 
//        type="org.iso.QRCode",
//        bounds={ 0.3,0.2 0.3x0.6 }
//        >corners { 0.4,0.8 0.7,0.7 0.6,0.2 0.3,0.3 }, 
//        time 315779740174375, 
//        stringValue "http://weixin.qq.com/r/nsTRySbE43ucrWKq95GM")
        
        clearLayers()
        
        guard let metadata = metadataObjects.last as? AVMetadataObject else {
            return
        }
        
        //转换前：corners { 0.4,0.8 0.7,0.7 0.6,0.2 0.3,0.3 }
        //转换后：corners { 63.1,206.5 81.0,423.0 299.3,411.8 284.5,185.9 }
        let objc = previewLayer.transformedMetadataObject(for: metadata)
        
        print((objc as! AVMetadataMachineReadableCodeObject).corners)
        
        //对扫描到的二维码进行描边
        drawLines(objc: objc as! AVMetadataMachineReadableCodeObject)
    }
    
    //绘制描边
    private func drawLines(objc : AVMetadataMachineReadableCodeObject) {
        //安全校验
        guard let array = objc.corners else {
            return
        }
        
        //创建图层，用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.orange.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        //创建UIBezierPath 绘制矩形
        let path = UIBezierPath()
        var point = CGPoint.zero
        var index = 0
        point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
        index = index + 1
        
        //将起点移动到某一个点
        path.move(to: point)
        
        //连接其他线段
        while index < array.count {
            point = CGPoint.init(dictionaryRepresentation: (array[index] as! CFDictionary))!
            index = index + 1
            path.addLine(to: point)
        }
        
        //关闭路径
        path.close()
        
        layer.path = path.cgPath
        
        //将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else {
            return
        }
        
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}


