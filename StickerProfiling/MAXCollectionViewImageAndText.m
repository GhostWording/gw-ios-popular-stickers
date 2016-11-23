//
//  MAXCollectionViewImageAndText.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 28/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXCollectionViewImageAndText.h"
#import "MAXCollectionViewCellImageAndText.h"

@interface MAXCollectionViewImageAndText() <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate> {
    
    
    
}

@end

@implementation MAXCollectionViewImageAndText

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self p_setupCollectionViewImageAndTextWithFrame:frame];
        
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setupCollectionViewImageAndTextWithFrame:CGRectZero];
    }
    
    return self;
}

-(id)init {
    return [self initWithFrame:CGRectZero];
}

#pragma mark - Setters

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGRect collectionViewFrame = CGRectZero;
    
    if (frame.size.width != 0 && frame.size.height > 64) {
        collectionViewFrame = CGRectMake(0, CGRectGetHeight(_headerView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - 64);
    }
    
    _collectionView.frame = CGRectMake(0, CGRectGetHeight(_headerView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(_headerView.frame));
    
}

#pragma mark - Private Setup

-(void)p_setupCollectionViewImageAndTextWithFrame:(CGRect)theFrame {
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 64)];
    [self addSubview:_headerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    CGRect collectionViewFrame = CGRectZero;
    
    if (theFrame.size.width != 0 && theFrame.size.height > CGRectGetHeight(_headerView.frame)) {
        collectionViewFrame = CGRectMake(0, CGRectGetHeight(_headerView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(_headerView.frame));
    }
    
    _collectionView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[MAXCollectionViewCellImageAndText class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    [self addSubview:_collectionView];
    
}

#pragma mark - Collection View Delegate 
    

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.datasource respondsToSelector:@selector(MAXCollectionViewSizeAtIndexPath:)] == YES) {
        return [self.datasource MAXCollectionViewSizeAtIndexPath:indexPath];
    }
    
    float height = CGRectGetWidth(collectionView.frame) / 2.0;
    return CGSizeMake(height, height + 30);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


#pragma mark - Collection view data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if ([self.datasource respondsToSelector:@selector(MAXCollectionViewImageAndTextNumSections)] == YES) {
        return [self.datasource MAXCollectionViewImageAndTextNumSections];
    }
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([self.datasource respondsToSelector:@selector(MAXCollectionViewImageAndTextNumItemsInSection:)] == YES) {
        return [self.datasource MAXCollectionViewImageAndTextNumItemsInSection:section];
    }
    
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MAXCollectionViewCellImageAndText *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([self.datasource respondsToSelector:@selector(MAXTitleInSection:atIndex:)] == YES) {
        NSString *titleText = [self.datasource MAXTitleInSection:indexPath.section atIndex:indexPath.item];
        if (titleText != nil) {
            cell.titleLabel.text = titleText;
        }
    }
    
    if (_cellLabelFont != nil) {
        cell.titleLabel.font = _cellLabelFont;
    }
    
    if (_cellLabelColor != nil) {
        cell.titleLabel.textColor = _cellLabelColor;
    }
    
    cell.titleLabel.adjustsFontSizeToFitWidth = YES;
    cell.titleLabel.minimumScaleFactor = 0.7;
    
    
    if ([self.datasource respondsToSelector:@selector(MAXImageInSection:atIndex:)] == YES) {
        UIImage *cellImage = [self.datasource MAXImageInSection:indexPath.section atIndex:indexPath.item];
        cell.imageView.image = cellImage;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.layer.masksToBounds = YES;
    }
    
    if ([self.datasource respondsToSelector:@selector(MAXCollectionViewCell:atIndex:)] == YES) {
        [self.datasource MAXCollectionViewCell:cell atIndex:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"item in section: %d at index: %d", (int)indexPath.section, (int)indexPath.row);
    
    if ([self.datasource respondsToSelector:@selector(MAXSelectedItemInSection:atIndex:)] == YES) {
        
        [self.datasource MAXSelectedItemInSection:indexPath.section atIndex:indexPath.item];
    }
    
}



@end
