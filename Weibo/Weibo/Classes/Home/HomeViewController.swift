//
//  HomeViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/12.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

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
        
        tableView.estimatedRowHeight = 400
//        tableView.rowHeight = UITableViewAutomaticDimension
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
            self.cachesImages(viewModels)
        }
    }
    
    fileprivate func cachesImages(_ viewModels : [StatusViewModel]) {
        
        //创建一个组
        let group = DispatchGroup()
        
        let queueDownLoad = DispatchQueue(label: "downLoad")
        queueDownLoad.async(group: group) {
            // 下载图书
            for viewModel in viewModels {
                //从模型取出配图数组
                guard let picurls = viewModel.thumbnail_pic else {
                    //如果当前微博没有配图，继续下载下一个模型
                    continue
                }
                //遍历配图数组下载图片
                for url in picurls {
                    print("图片下载完成")

                    //将当前的操作添加到组中
                    group.enter()
                    
                    //利用SDWebImage下载图片
                    SDWebImageManager.shared().downloadImage(with: url as URL!, options: SDWebImageOptions.init(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                        print("图片下载完成")
                        //将当前的操作从组中移除
                        group.leave()
                    })
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            // 下载完成
            print("全部下载完成")
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
    
    fileprivate var rowHeightCaches = [String : CGFloat]()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //取出当前数据
        let viewModel = viewModels?[indexPath.row]
        
        //没有缓存行高
        guard let height = rowHeightCaches[viewModel?.status.idstr ?? "-1"] else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
            //取出高度
            let temp = cell.calculatRowHeight(viewModel!)
            
            rowHeightCaches[viewModel?.status.idstr ?? "-1"] = temp
            
            return temp
        }
        
        return height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        rowHeightCaches.removeAll()
    }
    
}

///tableView代理
extension HomeViewController {
    
}





