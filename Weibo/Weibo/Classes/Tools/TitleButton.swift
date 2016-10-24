//
//  TitleButton.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/13.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    
    private func setupUI() {
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_down"), for: .normal)
        setImage(#imageLiteral(resourceName: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.gray, for: .normal)
        sizeToFit()
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        super.setTitle((title ?? "") + "  ", for: state)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.frame.size.width
        
    }

}
