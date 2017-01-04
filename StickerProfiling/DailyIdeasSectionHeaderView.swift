//
//  DailyIdeasSectionHeaderView.swift
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 12/3/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

import UIKit

class DailyIdeasSectionHeaderView: UICollectionReusableView {

    var _headerView : UIView = UIView()
    var headerView : UIView {
        
        get {
            return _headerView
        }
        
        set {
            
            _headerView = newValue
            newValue.removeFromSuperview()
            _headerView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            self.addSubview( _headerView )
            
        }
        
    }
    
}
