//
//  IntentionCell.swift
//  StickerBliss
//
//  Created by Mathieu Skulason on 11/07/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class IntentionCell: UITableViewCell {
    
    let intentionLabel = UILabel()
    let intentionImageView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(intentionLabel)
        self.addSubview(intentionImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        intentionImageView.frame = CGRectMake(15, CGRectGetHeight(self.frame) * 0.12, CGRectGetHeight(self.frame) * 0.76, CGRectGetHeight(self.frame) * 0.76)
        intentionLabel.frame = CGRectMake(CGRectGetMaxX(intentionImageView.frame) + 15, 0, CGRectGetWidth(self.frame) - CGRectGetMinX(intentionImageView.frame) - 15, CGRectGetHeight(self.frame))
        
    }
    
}
