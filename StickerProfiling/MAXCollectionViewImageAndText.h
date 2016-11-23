//
//  MAXCollectionViewImageAndText.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 28/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAXCollectionViewCellImageAndText;

@protocol MAXCollectionViewImageAndTextDataSource <NSObject>

@optional
-(NSInteger)MAXCollectionViewImageAndTextNumSections;
-(NSInteger)MAXCollectionViewImageAndTextNumItemsInSection:(NSInteger)theSection;

-(NSString*)MAXTitleInSection:(NSInteger)theSection atIndex:(NSInteger)theIndex;
-(UIImage*)MAXImageInSection:(NSInteger)theSection atIndex:(NSInteger)theIndex;

-(void)MAXCollectionViewCell:(MAXCollectionViewCellImageAndText *)theCell atIndex:(NSIndexPath *)theIndexPath;
-(CGSize)MAXCollectionViewSizeAtIndexPath:(NSIndexPath *)theIndexPath;

-(void)MAXSelectedItemInSection:(NSInteger)theSection atIndex:(NSInteger)theIndex;

@end

@interface MAXCollectionViewImageAndText : UIView

/**
 @abstrct Instead of a navigation bar we have a header view so titles and back buttons can be added on demand.
 */
@property (nonatomic, strong) UIView *headerView;

/**
 @abstract Color of the label of the collection view cell.
 */
@property (nonatomic, strong) UIColor *cellLabelColor;

/**
 @abstract Font of the label of the collection view cell.
 */
@property (nonatomic, strong) UIFont *cellLabelFont;

/**
 @abstrct The collection view used to present the images and texts.
 */
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 @bastract used as the simplified datasource of the collection view instead of exposing the complex datasource of the collection view
 */
@property (nonatomic, strong) id <MAXCollectionViewImageAndTextDataSource> datasource;



@end
