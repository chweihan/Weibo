//
//  HomeTableViewCell.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/25.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeTableViewCell: UITableViewCell {
    /// 配图视图
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    /// 配图布局对象
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    /// 配图高度约束
    @IBOutlet weak var pictureCollectionViewHeightCons: NSLayoutConstraint!
    // 配图宽度约束
    @IBOutlet weak var pictureCollectionViewWidthCons: NSLayoutConstraint!
    /// 头像
    @IBOutlet weak var iconImageView: UIImageView!
    /// 认证图标
    @IBOutlet weak var verifiedImageView: UIImageView!
    /// 昵称
    @IBOutlet weak var nameLabel: UILabel!
    /// 会员图标
    @IBOutlet weak var vipImageView: UIImageView!
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    /// 正文
    @IBOutlet weak var contentLabel: UILabel!
    /// 底部视图
    @IBOutlet weak var footerView: UIView!
    
    // MARK: - 重写frame
    override var frame: CGRect {
        didSet {
            var newFrame = frame
//            newFrame.origin.x = 10
//            newFrame.size.width -= 2 * 10
            newFrame.size.height -= 10
            newFrame.origin.y += 10
            super.frame = newFrame
        }
    }
    
    var viewModel : StatusViewModel? {
        didSet{
            //设置头像
            iconImageView.sd_setImage(with: viewModel?.icon_URL as URL!, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            //设置认证图标
            verifiedImageView.image = viewModel?.verified_image
            //设置昵称
            nameLabel.text = viewModel?.status.user?.screen_name
            //设置会员图标
            vipImageView.image = nil
            nameLabel.textColor = UIColor.black
            if let vipImage = viewModel?.mbrankImage {
                vipImageView.image = vipImage
                nameLabel.textColor = UIColor.orange
            }
            //设置时间 Tue Oct 25 15:53:46 +0800 2016
            timeLabel.text = viewModel?.created_Time
            //设置来源
            sourceLabel.text = viewModel?.source_Text
            //设置正文
            contentLabel.text = viewModel?.status.text
            //更新图片
            pictureCollectionView.reloadData()
            //更新配图尺寸
            let (itemSize,clvSize) = calculateSize()
            if itemSize != CGSize.zero {
                flowLayout.itemSize = itemSize
            }
            //更新cell尺寸
            pictureCollectionViewWidthCons.constant = clvSize.width
            pictureCollectionViewHeightCons.constant = clvSize.height
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 2 * 10
    }
    
    // MARK: - 外部控制方法
    func calculatRowHeight(_ viewModel : StatusViewModel) -> CGFloat {
        //设置数据
        self.viewModel = viewModel
        //更新ui
        self.layoutIfNeeded()
        
        //返回底部视图最大的y
        return footerView.frame.origin.y + footerView.frame.size.height
    
    }
    
    // MARK: - 内部控制方法
    fileprivate func calculateSize() -> (CGSize, CGSize) {
        
        let count = viewModel?.thumbnail_pic?.count ?? 0
        
        if count == 0 {
            return (CGSize.zero, CGSize.zero)
        }
        
        if count == 1 {
            let key = viewModel?.thumbnail_pic?.first?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: key)
            return ((image?.size)!,(image?.size)!)
        }
        
        let imageWidth = 90
        let imageHeight = 90
        let imageMargin = 10
        
        if count == 4 {
            
            let col = 2
            let row = col
            
            // 宽度 = 图片的宽度 * 列数 + (列数 - 1) * 间隙
            let width = imageWidth * col + (col - 1) * imageMargin
            // 高度 = 图片的高度 * 行数 + (行数 - 1) * 间隙
            let height = imageHeight * row + (row - 1) * imageMargin
            
            return (CGSize.init(width: imageWidth, height: imageHeight),CGSize.init(width: width, height: height))
        }
        
        let col = 3
        let row = (count - 1) / col + 1
        
        let width = imageWidth * col + (col - 1) * imageMargin
        let height = imageHeight * row + (row - 1) * imageMargin
        
        return (CGSize.init(width: imageWidth, height: imageHeight),CGSize.init(width: width, height: height))
    }
    
    
}


extension HomeTableViewCell : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.thumbnail_pic?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! HomePictureCell
        cell.url = viewModel?.thumbnail_pic![indexPath.item]
        return cell
    }
}

class HomePictureCell: UICollectionViewCell {
    var url : NSURL? {
        didSet {
            customIconImageView.sd_setImage(with: url as URL!)
        }
    }
    
    @IBOutlet weak var customIconImageView: UIImageView!
}

