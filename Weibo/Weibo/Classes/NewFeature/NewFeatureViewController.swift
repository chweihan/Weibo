//
//  NewFeatureViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/21.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SnapKit

class NewFeatureViewController: UIViewController {
    
    var maxCount = 4

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension NewFeatureViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newfeatureCell", for: indexPath) as! WHNewfeatureCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.purple : UIColor.orange
        //设置数据
        cell.index = indexPath.item
        
        return cell
    }
}

extension NewFeatureViewController : UICollectionViewDelegate {
    
    @objc(collectionView:didEndDisplayingCell:forItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
//        print(indexPath.item)
        
        //手动获取当前显示的cell对应的indexPath
        let index = collectionView.indexPathsForVisibleItems.last
        
        guard let i = index else {
            return
        }
        
//        print(i.item)

        //根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItem(at: i) as! WHNewfeatureCell
        if i.item == 3 {
            currentCell.startAniamtion()
        }

    }
    
}


class WHNewfeatureCell: UICollectionViewCell {
    var index : Int = 0 {
        didSet{
            //生成图片名称
            let name = "new_feature_\(index + 1)"
            //设置图片
            iconView.image = UIImage(named: name)
            startButton.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //初始化UI
        setupUI()
    }
    
    // MARK: - 外部控制方法
    func startAniamtion() {
        startButton.isHidden = false
        startButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        startButton.isUserInteractionEnabled = false
        // 执行放大动画
        /*
         第一个参数: 动画时间
         第二个参数: 延迟时间
         第三个参数: 震幅 0.0~1.0, 值越小震动越列害
         第四个参数: 加速度, 值越大震动越列害
         第五个参数: 动画附加属性
         第六个参数: 执行动画的block
         第七个参数: 执行完毕后回调的block
         */
        UIView.animate(withDuration: 2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { 
            self.startButton.transform = CGAffineTransform.identity
            }) { (_) in
                self.startButton.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - 内部控制方法
    fileprivate func setupUI() {
        //添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        //布局子控件
        iconView.snp.makeConstraints { (make) in
             make.edges.equalTo(0)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
    }
    
    func startButtonClick() {
        print("startButtonClick")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: WHSwitchRootViewController), object: true)
        
    }
    
    // MARK: - 懒加载
    //图片容器
    lazy var iconView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    //开始按钮
    lazy var startButton : UIButton = {
        let btn = UIButton(nil, "new_feature_button")
        btn.addTarget(self, action: #selector(self.startButtonClick), for: .touchUpInside)
        return btn
    }()
}

class WHNewfeatureLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        //设置每个cell的尺寸
        itemSize = UIScreen.main.bounds.size
        //设置cell之前的间隔
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        //设置滚动方向
        scrollDirection = .horizontal
        //设置分页
        collectionView?.isPagingEnabled = true
        //禁用回弹
        collectionView?.bounces = false
        //取出滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
