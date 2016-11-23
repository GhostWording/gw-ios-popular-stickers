//
//  MAXPageControl.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 30/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXPageControl.h"

@interface MAXPageControl () {
    NSMutableArray *_pageIndicators;
}

@end

const float p_defaultIndicatorSize = 10;
const float p_defaultIndicatorSpace = 8;

@implementation MAXPageControl

#pragma mark - Class Initializers

+(instancetype)MAXPageControlWithCenter:(CGPoint)theCenterPoint numberOfPages:(NSInteger)theNumberOfPages {
    
    CGRect frame = [self p_calculateFrameBasedOnCenterPoint:theCenterPoint numberOfPages:theNumberOfPages indicatorSize:p_defaultIndicatorSize indicatorSpace:p_defaultIndicatorSpace];
    
    MAXPageControl *control = [[MAXPageControl alloc] initWithFrame:frame alignment:MAXPageControlAlignmentCenter numberOfPages:theNumberOfPages indicatorSize:p_defaultIndicatorSize indicatorSpace:p_defaultIndicatorSpace];
    
    return control;
}

+(instancetype)MAXPageControlWithCenter:(CGPoint)theCenterPoint numberOfPages:(NSInteger)theNumberOfPages indicatorSize:(float)theIndicatorSize indicatorSpace:(float)theIndicatorSpace {
    
    CGRect frame = [self p_calculateFrameBasedOnCenterPoint:theCenterPoint numberOfPages:theNumberOfPages indicatorSize:theIndicatorSize indicatorSpace:theIndicatorSpace];
    
    MAXPageControl *control = [[MAXPageControl alloc] initWithFrame:frame alignment:MAXPageControlAlignmentCenter numberOfPages:theNumberOfPages indicatorSize:theIndicatorSize indicatorSpace:theIndicatorSpace];
    
    return control;
}

+(CGRect)p_calculateFrameBasedOnCenterPoint:(CGPoint)theCenterPoint numberOfPages:(NSInteger)theNumberOfPages indicatorSize:(float)theIndicatorSize indicatorSpace:(float)theIndicatorSpace {
    
    float dist = theNumberOfPages * theIndicatorSize + (theNumberOfPages - 1) * theIndicatorSpace;
    
    float startPoint = dist / 2.0;
    
    return CGRectMake(startPoint, theCenterPoint.y - theIndicatorSize / 2.0, theIndicatorSize, theIndicatorSize);
    
}

#pragma mark - Private Initializers

-(id)initWithFrame:(CGRect)frame alignment:(MAXPageControlAlignment)theAlignment numberOfPages:(NSInteger)theNumberOfPages indicatorSize:(float)theIndicatorSize indicatorSpace:(float)theIndicatorSpace {
    
    if (self = [super initWithFrame:frame]) {
        
        _numberOfPages = theNumberOfPages;
        _currentPage = 0;
        _indicatorSize = theIndicatorSize;
        _indicatorSpace = theIndicatorSpace;
        _indicatorBorderSize = theIndicatorSize / 8.0;
        
        _pageControlAlignment = theAlignment;
        _pageIndicators = [NSMutableArray array];
        
        
        _pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageIndicatorBorderTintColor = [UIColor clearColor];
        
        _currentPageIndicatorTintColor = [UIColor whiteColor];
        _currentPageIndicatorBorderTintColor = [UIColor clearColor];
        
        [self p_populateIndicators:_pageIndicators numberOfIndicators:_numberOfPages];
        [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
        
    }
    
    
    return self;
}


-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame alignment:MAXPageControlAlignmentCenter numberOfPages:0 indicatorSize:p_defaultIndicatorSize indicatorSpace:p_defaultIndicatorSpace];
}

-(id)init {
    return [self initWithFrame:CGRectZero alignment:MAXPageControlAlignmentCenter numberOfPages:0 indicatorSize:p_defaultIndicatorSize indicatorSpace:p_defaultIndicatorSpace];
}


#pragma mark - Setters

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self p_populateIndicators:_pageIndicators numberOfIndicators:_numberOfPages];
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setIndicatorSize:(float)indicatorSize {
    _indicatorSize = indicatorSize;
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setIndicatorSpace:(float)indicatorSpace {
    _indicatorSpace = indicatorSpace;
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setIndicatorBorderSize:(float)indicatorBorderSize {
    _indicatorBorderSize = indicatorBorderSize;
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setPageControlAlignment:(MAXPageControlAlignment)pageControlAlignment {
    _pageControlAlignment = pageControlAlignment;
    [self p_layoutIndicatorsWithAlignment:_pageControlAlignment indicator:_pageIndicators];
}

-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    _pageIndicatorTintColor = pageIndicatorTintColor;
    [self p_setColorForIndicators:_pageIndicators];
}

-(void)setPageIndicatorBorderTintColor:(UIColor *)pageIndicatorBorderTintColor {
    _pageIndicatorBorderTintColor = pageIndicatorBorderTintColor;
    [self p_setColorForIndicators:_pageIndicators];
}

-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    [self p_setColorForIndicators:_pageIndicators];
}

-(void)setCurrentPageIndicatorBorderTintColor:(UIColor *)currentPageIndicatorBorderTintColor {
    _currentPageIndicatorBorderTintColor = currentPageIndicatorBorderTintColor;
    [self p_setColorForIndicators:_pageIndicators];
}

#pragma mark - Laying out the indicators


-(void)p_layoutIndicatorsWithAlignment:(MAXPageControlAlignment)theAlignment indicator:(NSMutableArray*)theIndicators {
    
    if (theAlignment == MAXPageControlAlignmentLeft) {
        [self p_layountIndicatorsLeftWithIndicators:theIndicators];
    }
    else if(theAlignment == MAXPageControlAlignmentCenter) {
        [self p_layoutIndicatorsCenterWithIndicators:theIndicators];
    }
    else if(theAlignment == MAXPageControlAlignmentRight) {
        [self p_layoutIndicatorsRightWithIndicators:theIndicators];
    }
    
    [self p_setColorForIndicators:theIndicators];
}

-(void)p_layountIndicatorsLeftWithIndicators:(NSMutableArray *)theIndicators {
    
    int numIndictator = 0;
    for (UIView *view in theIndicators) {
        
        view.frame = CGRectMake(_indicatorSize * numIndictator + _indicatorSpace * numIndictator, CGRectGetHeight(self.frame) / 2.0 - _indicatorSize / 2.0, _indicatorSize, _indicatorSize);
        view.layer.borderWidth = _indicatorBorderSize;
        view.layer.cornerRadius = _indicatorSize / 2.0;
        
        numIndictator++;
    }
    
}

-(void)p_layoutIndicatorsCenterWithIndicators:(NSMutableArray *)theIndicators {
    
    float dist = theIndicators.count * _indicatorSize + _indicatorSpace * (theIndicators.count - 1);
    
    float centerOfControl = CGRectGetWidth(self.frame) / 2.0;
    float startPoint = centerOfControl - dist / 2.0;
    
    int numIndicator = 0;
    for (UIView *view in theIndicators) {
        
        view.frame = CGRectMake(startPoint + _indicatorSize * numIndicator + _indicatorSpace * numIndicator, CGRectGetHeight(self.frame) / 2.0 - _indicatorSize / 2.0, _indicatorSize, _indicatorSize);
        view.layer.borderWidth = _indicatorBorderSize;
        view.layer.cornerRadius = _indicatorSize / 2.0;
        
        numIndicator++;
    }
    
    
}

-(void)p_layoutIndicatorsRightWithIndicators:(NSMutableArray *)theIndicators {
    
    float dist = theIndicators.count * _indicatorSize + _indicatorSpace * (theIndicators.count -1);
    
    float startPoint = CGRectGetWidth(self.frame) - dist;
    
    int numIndiactor = 0;
    for (UIView *view  in theIndicators) {
        
        view.frame = CGRectMake(startPoint + _indicatorSpace *numIndiactor + _indicatorSpace *numIndiactor, CGRectGetHeight(self.frame) / 2.0, _indicatorSize, _indicatorSize);
        view.layer.borderWidth = _indicatorBorderSize;
        view.layer.cornerRadius = _indicatorSize / 2.0;
        
        numIndiactor++;
    }
    
}

-(void)p_setColorForIndicators:(NSMutableArray*)theIndicators {
    [self p_setDefaultColorForIndicators:theIndicators];
    [self p_setCurrentPageColorForIndicators:theIndicators];
}

-(void)p_setDefaultColorForIndicators:(NSMutableArray*)theIndicators {
    
    for (UIView *view in  theIndicators) {
        view.layer.backgroundColor = _pageIndicatorTintColor.CGColor;
        view.layer.borderColor = _pageIndicatorBorderTintColor.CGColor;
    }
    
}

-(void)p_setCurrentPageColorForIndicators:(NSMutableArray *)theIndicators {
    
    if (_currentPage < theIndicators.count) {
        
        UIView *currentIndicator = [theIndicators objectAtIndex:_currentPage];
        currentIndicator.layer.backgroundColor = _currentPageIndicatorTintColor.CGColor;
        currentIndicator.layer.borderColor = _currentPageIndicatorBorderTintColor.CGColor;
        
    }
    
}

/**
 @abstract Checks how many indicators are in the array and how many indicators we need to render and then adds the missing number of indicators tot he array.
 */
-(void)p_populateIndicators:(NSMutableArray*)theIndicators numberOfIndicators:(NSInteger)theNumberOfIndiactors {
    
    NSInteger numIndicatorsToAdd = theNumberOfIndiactors - theIndicators.count;
    
    for (int i = 0; i < numIndicatorsToAdd; i++) {
        
        UIView *newIndicator = [[UIView alloc] init];
        [theIndicators addObject:newIndicator];
        [self addSubview:newIndicator];
    }
}



@end
