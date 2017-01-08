//
//  MAXImageAndTextHeaderViewCell.m
//  StickerBliss
//
//  Created by Mathieu Grettir Skulason on 12/3/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXImageAndTextHeaderViewCell.h"

@interface MAXImageAndTextHeaderViewCell ()


@end

@implementation MAXImageAndTextHeaderViewCell

-(void)setHeaderView:(UIView *)headerView {
    
    if (_headerView != nil) {
        [_headerView removeFromSuperview];
    }
    
    _headerView = headerView;
    
    _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(headerView.frame), CGRectGetHeight(headerView.frame));
    [self addSubview: _headerView];
}

@end
