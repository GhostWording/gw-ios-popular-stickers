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
    
    fileprivate func setup() {
        
        popularTextLabel.textAlignment = .center
        popularTextLabel.textColor = UIColor.black
        popularTextLabel.font = UIFont.c_robotoMedium(withSize: 15.0)
        popularTextLabel.numberOfLines = 0
        
        self.addSubview(popularTextLabel)
        
        self.addSubview(nbSharesImageView)
        self.addSubview(nbSharesLabel)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func messengerButtonTouchedDown() {
        
//        self.messengerButtonPressed?()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        
        nbSharesImageView.frame = CGRect(x: self.frame.midX - 20 - 8, y: self.frame.height - 24, width: 16, height: 16)
        
        nbSharesLabel.frame = CGRect(x: nbSharesImageView.frame.maxX + 4, y: nbSharesImageView.frame.minY, width: 40, height: 16)
        
        
        
        if nbSharesImageView.isHidden == false {
            popularTextLabel.frame = CGRect(x: self.frame.width * 0.1, y: 15, width: self.frame.width * 0.8, height: self.frame.height - 50)
        }
        else {
            popularTextLabel.frame = CGRect(x: self.frame.width * 0.1, y: 15, width: self.frame.width * 0.8, height: self.frame.height - 30)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
