//
//  DailyIdeasCollectionViewCell.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 11/19/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class DailyIdeasCollectionViewCell: UICollectionViewCell {

    fileprivate let containerView : UIView
    let imageView : UIImageView
    let titleLabel : UILabel
    let sendButton : MAXFadeBlockButton
    
    
    override init(frame: CGRect) {
        
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 60))
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: UIScreen.main.bounds.size.width * 0.7))
        titleLabel = UILabel(frame: CGRect(x: containerView.frame.width * 0.1, y: imageView.frame.height, width: frame.width * 0.8, height: containerView.frame.height - imageView.frame.height))
        sendButton = MAXFadeBlockButton(frame: CGRect(x: 0, y: containerView.frame.height + 20, width: frame.width, height: 40))
        
        super.init(frame: frame)
        
        self.containerView.backgroundColor = UIColor.white
        self.containerView.layer.cornerRadius = 8.0
        self.containerView.layer.masksToBounds = true
        
        self.imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.imageView.layer.masksToBounds = true
        
        self.titleLabel.textAlignment = .center
        self.titleLabel.font = UIFont.c_robotoMedium( withSize: 14.0 )
        self.titleLabel.numberOfLines = 0
        
        self.sendButton.layer.cornerRadius = 5.0
        self.sendButton.backgroundColor = UIColor.c_blue()
        self.sendButton.titleLabel?.font = UIFont.c_robotoMedium( withSize: 15.0 )
        self.sendButton.setTitleColor(UIColor.white, for: UIControlState())
        self.sendButton.setTitle(PopularStickersLocalizedString("<Send>", nil), for: UIControlState())
        
        
        self.addSubview( containerView )
        containerView.addSubview( imageView )
        containerView.addSubview( titleLabel )
        self.addSubview( sendButton )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 60)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: UIScreen.main.bounds.size.width * 0.7)
        titleLabel.frame = CGRect(x: self.frame.width * 0.1, y: imageView.frame.height, width: frame.width * 0.8, height: containerView.frame.height - imageView.frame.height)
        sendButton.frame = CGRect(x: 0, y: containerView.frame.height + 20, width: frame.width, height: 40)
        
    }
    
}
