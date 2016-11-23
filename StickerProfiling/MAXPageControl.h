//
//  MAXPageControl.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 30/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, MAXPageControlAlignment) {
    MAXPageControlAlignmentCenter,
    MAXPageControlAlignmentLeft,
    MAXPageControlAlignmentRight
};

NS_ASSUME_NONNULL_BEGIN

@interface MAXPageControl : UIView

/**
 @abstract Initializes a new page control which automatically resizes its frame based on the number of pages chosen from the center point using the default indicator size and indicator spacing. It defaults to center alignment.
 */
+(instancetype)MAXPageControlWithCenter:(CGPoint)theCenterPoint numberOfPages:(NSInteger)theNumberOfPages;

/**
 @abstract Initializes a new page control which automatically resizes its frame based on the number of pages chosen, the center poing and the size and indicator space. It defaults to center alignment.
 */
+(instancetype)MAXPageControlWithCenter:(CGPoint)theCenterPoint numberOfPages:(NSInteger)theNumberOfPages indicatorSize:(float)theIndicatorSize indicatorSpace:(float)theIndicatorSpace;


/**
 @abstract The number of pages the indicator has. When set the frame is resized and the indiactors are laid out again.
 */
@property (nonatomic, readwrite) NSInteger numberOfPages;

/**
 @abstract The current page of the indicator. Zero indexed to match the array.
 */
@property (nonatomic, readwrite) NSInteger currentPage;

/**
 @abstract The size of the page indicators. When set the frame is resized and the indiactors are laid out again.
 */
@property (nonatomic, readwrite) float indicatorSize;

/**
 @abstract The space between the indicators. When set the frame is resized and the indiactors are laid out again.
 */
@property (nonatomic, readwrite) float indicatorSpace;

/**
 @abstract The border size of the indicator which becomes the size of the border tint color.
 */
@property (nonatomic, readwrite) float indicatorBorderSize;

/**
 @abstract Set the alignment of the page control. Defaults to Center alignment. When set the indicators are laid out again.
 */
@property (nonatomic, readwrite) MAXPageControlAlignment pageControlAlignment;

/**
 @abstract Set the direction of the page control, it can be vertical or horizontal. Defaults to horizontal Direction.
 */
//@property (nonatomic, readonly) MAXPageControlDirection pageControlDirection;

/**
 @abstract The tint color of the page indicator when it is not the currently selected indicator.
 */
@property (nonatomic, strong, readwrite) UIColor *pageIndicatorTintColor;

/**
 @abstract The border tint color of the page indicator when it is not the currently selected indicator. Defaults to clearColor.
 */
@property (nonatomic, strong, readwrite) UIColor *pageIndicatorBorderTintColor;

/**
 @abstract The tint color of the currently selected page indicator. Defaults to light gray color.
 */
@property (nonatomic, strong, readwrite) UIColor *currentPageIndicatorTintColor;

/**
 @abstract The border tint color of the current selected page indicator. Defaults to clearColor. Defaults to white color.
 */
@property (nonatomic, strong, readwrite) UIColor *currentPageIndicatorBorderTintColor;


/**
 @abstract The designated initializer of the page control so you can customize it using the various properties right away.
 */
-(id)initWithFrame:(CGRect)frame alignment:(MAXPageControlAlignment)theAlignment numberOfPages:(NSInteger)theNumberOfPages indicatorSize:(float)theIndicatorSize indicatorSpace:(float)theIndicatorSpace;

@end

NS_ASSUME_NONNULL_END
