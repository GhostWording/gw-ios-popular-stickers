//
//  MAXCollectionViewCellImageAndText.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 28/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAXCollectionViewCellImageAndText : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic) CGRect imageViewFrame;
@property (nonatomic) CGRect titleLabelFrame;

@end
