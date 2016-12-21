//
//  MAXCollectionViewCellImageAndText.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 28/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBAudienceNetwork/FBAudienceNetwork.h>

typedef NS_ENUM(NSInteger, MAXCellType) {
    MAXCellTypeImage = 0,
    MAXCellTypeAdvert = 1,
};

@interface MAXCollectionViewCellImageAndText : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, strong, readonly) UIImageView *logoImageView;
@property (nonatomic, strong, readonly) UILabel *sponsoredLabel;
@property (nonatomic, strong, readonly) FBAdChoicesView *adChoiceLabel;
@property (nonatomic, strong, readonly) UILabel *adSocialContextLabel;
@property (nonatomic, strong, readonly) UILabel *adBodyLabel;
@property (nonatomic, strong, readonly) UIButton *callToActionButton;
@property (nonatomic, strong) FBMediaView *adMediaView;

@property (nonatomic) CGRect imageViewFrame;
@property (nonatomic) CGRect titleLabelFrame;

@property (nonatomic) MAXCellType type;

@end
