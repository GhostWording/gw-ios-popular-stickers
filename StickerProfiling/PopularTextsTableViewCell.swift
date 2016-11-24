//
//  PopularTextsTableViewCell.swift
//  PopularStickers
//
//  Created by Mathieu Skulason on 16/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class PopularTextsTableViewCell: UITableViewCell {

    var popularTextLabel = UILabel()
    
    var nbSharesImageView = UIImageView()
    var nbSharesLabel = UILabel()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        
        popularTextLabel.textAlignment = .Center
        popularTextLabel.textColor = UIColor.blackColor()
        popularTextLabel.font = UIFont.c_robotoMediumWithSize(15.0)
        popularTextLabel.numberOfLines = 0
        
        self.addSubview(popularTextLabel)
        
        self.addSubview(nbSharesImageView)
        self.addSubview(nbSharesLabel)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func messengerButtonTouchedDown() {
        
//        self.messengerButtonPressed?()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        
        nbSharesImageView.frame = CGRectMake(CGRectGetMidX(self.frame) - 20 - 8, CGRectGetHeight(self.frame) - 18, 16, 16)
        
        nbSharesLabel.frame = CGRectMake(CGRectGetMaxX(nbSharesImageView.frame) + 4, CGRectGetMinY(nbSharesImageView.frame), 40, 16)
        
        popularTextLabel.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.1, CGRectGetHeight(self.frame) * 0.07, CGRectGetWidth(self.frame) * 0.8, CGRectGetHeight(self.frame) - CGRectGetHeight(self.frame) * 0.1 - CGRectGetHeight(nbSharesImageView.frame) - 4)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
