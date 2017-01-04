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
        
        intentionImageView.frame = CGRect(x: 15, y: self.frame.height * 0.12, width: self.frame.height * 0.76, height: self.frame.height * 0.76)
        intentionLabel.frame = CGRect(x: intentionImageView.frame.maxX + 15, y: 0, width: self.frame.width - intentionImageView.frame.minX - 15, height: self.frame.height)
        
    }
    
}
