//
//  MainViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBar.addSubview(composeButton)
        
        //保存之前的尺寸
        let rect = composeButton.frame
        //计算宽度
        let width = tabBar.frame.width / CGFloat(childViewControllers.count)
        //设置按钮位置
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
        
    }
    
//    //添加所有自控制器
//    func addChildViewControllers() {
//        
////        //根据json文件创建控制器
////        //读取json数据
////        guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
////            print("JSON文件不存在")
////            return
////        }
////        
////        guard let data = NSData(contentsOfFile: filePath) else {
////            print("加载二进制数据失败")
////            return
////        }
////        
////        //将json数据转换为对象(数据字典)
////        do {
////            let objc = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as! [[String : AnyObject]]
////            
////            for dict in objc {
////                //根据遍历到的字典创建控制器
////                let vcName = dict["vcName"] as? String
////                let title = dict["title"] as? String
////                let imageName = dict["imageName"] as? String
////                addChildViewController(childControllerName: vcName, title: title, imageName: imageName)
////            }
////            
////        }catch {
////            
////        }
//        
//        addChildViewController(childControllerName: "HomeViewController", title: "首页", imageName: "tabbar_home")
//        addChildViewController(childControllerName: "MessageViewController", title: "消息", imageName: "tabbar_message_center")
//        addChildViewController(childControllerName: "NullViewController", title: "", imageName: "")
//        addChildViewController(childControllerName: "DiscoverViewController", title: "发现", imageName: "tabbar_discover")
//        addChildViewController(childControllerName: "ProfileViewController", title: "我的", imageName: "tabbar_profile")
//        
//    }
//    
//    //添加子控制器
//    func addChildViewController(childControllerName : String , title : String , imageName : String){
//        
//        // 动态获取命名空间
//        // 由于字典/数组只能存储对象,所以通过一个key从字典中获取值取出来是一个AnyObject类型，并且如果key写错或者没有对应的值,那么就取不到值,所以返回值可以有值也可能没有值,所以最终的类型是AnyObject?
//        guard let name = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
//            print("获取命名空间失败")
//            return
//        }
//        
//        //swift中有命名空间，所以通过一个字符创来创建一个类必须加上命名空间
//        let cls : AnyClass? = NSClassFromString(name + "." + childControllerName)
//        //swift中如果想通过一个class来创建一个对象，必须告诉系统这个class的确切类型
//        guard let typeCls = cls as? UITableViewController.Type else {
//            print("cls不能当做UITbaleViewController")
//            return
//        }
//        
//        //通过class创建对象
//        let childController = typeCls.init()
//        
//        //设置子控制器的属性
//        childController.title = title
//        childController.tabBarItem.image = UIImage(named: imageName)
//        childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
//        //设置导航栏
//        let navi = UINavigationController(rootViewController: childController)
//        //添加子控制器
//        addChildViewController(navi)
//    
//    }
    
    // MARK:- 懒加载
    lazy var composeButton : UIButton = {
        //创建按钮
        let btn = UIButton("tabbar_compose_icon_add", "tabbar_compose_button")
        //设置按钮监听
        btn.addTarget(self, action: #selector(self.composeBtnClick), for: .touchUpInside)
        
        return btn
    }()
    
    //composeBtn点击事件
    func composeBtnClick() {
        print("composeBtn点击事件")
    }
}
