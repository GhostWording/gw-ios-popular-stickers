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
        
        _type = MAXCellTypeImage;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        _imageViewFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 5, CGRectGetWidth(self.frame) - 20, 20)];
        _titleLabelFrame = CGRectMake(10, CGRectGetMaxY(_imageView.frame) + 5, CGRectGetWidth(self.frame) - 20, 20);
        [self addSubview:_titleLabel];
        
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.hidden = true;
        [self addSubview: _logoImageView];
        
        _sponsoredLabel = [[UILabel alloc] init];
        _sponsoredLabel.hidden = true;
        [self addSubview: _sponsoredLabel];
        
        _adChoiceLabel = [[FBAdChoicesView alloc] init];
        _adChoiceLabel.hidden = true;
        [self addSubview: _adChoiceLabel];
        
        _adSocialContextLabel = [[UILabel alloc] init];
        _adSocialContextLabel.hidden = true;
        [self addSubview: _adSocialContextLabel];
        
        _adBodyLabel = [[UILabel alloc] init];
        _adBodyLabel.hidden = true;
        [self addSubview: _adBodyLabel];
        
        _callToActionButton = [[UIButton alloc] init];
        _callToActionButton.hidden = true;
        [self addSubview: _callToActionButton];
        
        _adMediaView = [[FBMediaView alloc] init];
        _adMediaView.hidden = true;
        [self addSubview: _adMediaView];
        
    }
    
    return self;
}

#pragma mark - Setter

-(void)setType:(MAXCellType)type {
    
    _type = type;
    
    [self updateCellWithType: type];
    
}

-(void)setImageViewFrame:(CGRect)imageViewFrame {
    _imageViewFrame = imageViewFrame;
    [self layoutSubviews];
}

-(void)setTitleLabelFrame:(CGRect)titleLabelFrame {
    _titleLabelFrame = titleLabelFrame;
    [self layoutSubviews];
}

-(void)updateCellWithType:(MAXCellType)type {
    
    if (type == MAXCellTypeImage) {
        
        _imageView.hidden = false;
        _titleLabel.hidden = false;
        
        _logoImageView.hidden = true;
        _sponsoredLabel.hidden = true;
        _adChoiceLabel.hidden = true;
        _adSocialContextLabel.hidden = true;
        _adBodyLabel.hidden = true;
        _callToActionButton.hidden = true;
        _adMediaView.hidden = true;
        
        _imageView.frame = _imageViewFrame;
        _titleLabel.frame = _titleLabelFrame;
    }
    else if(type == MAXCellTypeAdvert) {
        
        _imageView.hidden = true;
        
        _logoImageView.hidden = false;
        _sponsoredLabel.hidden = false;
        _adChoiceLabel.hidden = false;
        _adSocialContextLabel.hidden = false;
        _adBodyLabel.hidden = false;
        _callToActionButton.hidden = false;
        _adMediaView.hidden = false;
        
        _logoImageView.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.12, CGRectGetWidth(self.frame) * 0.12);
        _titleLabel.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.19, CGRectGetWidth(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(_logoImageView.frame) * 0.5);
        _sponsoredLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_logoImageView.frame) * 0.3);
        _adChoiceLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame) * 0.2, CGRectGetWidth(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.2, CGRectGetWidth(self.frame) * 0.05);
        
        _adMediaView.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.15, CGRectGetWidth(self.frame) * 0.96, CGRectGetHeight(self.frame) * 0.56);
        _adSocialContextLabel.frame = CGRectMake(CGRectGetMinX(_adMediaView.frame), CGRectGetMaxY(_adMediaView.frame) + CGRectGetHeight(self.frame) * 0.02, CGRectGetWidth(self.frame) * 0.65, CGRectGetHeight(self.frame) * 0.05);
        _adBodyLabel.frame = CGRectMake(CGRectGetMinX(_adMediaView.frame), CGRectGetMaxY(_adSocialContextLabel.frame), CGRectGetWidth(_adSocialContextLabel.frame), CGRectGetHeight(self.frame) * 0.15);
        
        _callToActionButton.frame = CGRectMake(CGRectGetWidth(self.frame) * 0.7, CGRectGetMaxY(_adMediaView.frame) + CGRectGetHeight(self.frame) * 0.08, CGRectGetWidth(self.frame) * 0.25, CGRectGetHeight(self.frame) * 0.1);
    }
    
}

#pragma mark - Layout Subviews

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (_type == MAXCellTypeImage) {
        _imageView.frame = _imageViewFrame;
        _titleLabel.frame = _titleLabelFrame;
    }
    else {
        
    }
    
}

@end
