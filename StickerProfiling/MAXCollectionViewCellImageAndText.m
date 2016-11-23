//
//  MAXCollectionViewCellImageAndText.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 28/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXCollectionViewCellImageAndText.h"

@implementation MAXCollectionViewCellImageAndText

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        _imageViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 5, CGRectGetWidth(self.frame) - 20, 20)];
        _titleLabelFrame = CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 5, CGRectGetWidth(self.frame) - 20, 20);
        [self addSubview:_titleLabel];
        
    }
    
    return self;
}

-(void)setImageViewFrame:(CGRect)imageViewFrame {
    _imageViewFrame = imageViewFrame;
    [self layoutSubviews];
}

-(void)setTitleLabelFrame:(CGRect)titleLabelFrame {
    _titleLabelFrame = titleLabelFrame;
    [self layoutSubviews];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = _imageViewFrame;
    _titleLabel.frame = _titleLabelFrame;
}

@end
