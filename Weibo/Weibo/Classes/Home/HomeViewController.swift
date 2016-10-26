//
//  HomeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: BaseViewController {
    
    //保存所有微博数据
    var viewModels : [StatusViewModel]?{
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            touristView?.setupTouristViewInfo(imageName: nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        //添加导航栏视图
        setupNav()
        
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(self.titleChange), name: NSNotification.Name(rawValue: WHPresentationManagerDidPresented), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.titleChange), name: NSNotification.Name(rawValue: WHPresentationManagerDidDismissed), object: nil)
        
        //获取数据
        loadData()
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //获取数据
    func loadData() {
        
        NetworkTool.shareInstance.loadStatuses { (array : [[String : Any]]?, error: NSError?) in
            if error != nil {
                SVProgressHUD.showError(withStatus: "获取微博数据失败")
                return
            }
            guard let arr = array else {
                return
            }
            
            //将字典数组转换为模型数组
            var viewModels = [StatusViewModel]()
            for dict in arr {
                let status = Status(dict)
                let viewModel = StatusViewModel.init(status)
                viewModels.append(viewModel)
                print(viewModel.status)
            }
            //保存数据
            self.viewModels = viewModels
        }
    }
    
    //按钮点击事件
    func titleChange() {
        //修改按钮状态
        titleButton.isSelected = !titleButton.isSelected
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNav() {
        //设置左右两边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem("navigationbar_friendattention", self, #selector(self.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem("navigationbar_pop", self, #selector(self.rightBtnClick))
        
        //设置标题
        navigationItem.titleView = titleButton
    }
    
    func titleBtnClick(titleBtn : TitleButton) {
       
        //显示菜单,创建菜单
        guard let menuView = R.storyboard.popover.instantiateInitialViewController() else {
            return
        }
        
        menuView.transitioningDelegate = presentationManager
        menuView.modalPresentationStyle = .custom
        
        present(menuView, animated: true, completion: nil)
    }
    
    func leftBtnClick() {
        print("leftBtnClick")
    }
    
    func rightBtnClick() {
        let vc = R.storyboard.qRCode.instantiateInitialViewController()!
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    private lazy var presentationManager : WHPresentationManager = {
        let manager = WHPresentationManager()
        manager.presentedFrame = CGRect(x: 100, y: 45, width: 200, height: 200)
        return manager
    }()
    
    private lazy var titleButton : UIButton = {
        //设置标题
        let btn = TitleButton()
        btn.setTitle(UserAccount.loadUserAccount()?.screen_name, for: .normal)
        btn.addTarget(self, action: #selector(self.titleBtnClick(titleBtn:)), for: .touchUpInside)
        return btn
    }()
}

///tableView数据源
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeTableViewCell
        cell.viewModel = self.viewModels?[indexPath.row]
        return cell
    }
    
}

///tableView代理
extension HomeViewController {
    
}





