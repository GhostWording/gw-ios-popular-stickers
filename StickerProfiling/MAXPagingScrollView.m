//
//  MENIGAScrollView.m
//  bank42
//
//  Created by Mathieu Grettir Skulason on 2/22/16.
//  Copyright © 2016 Meniga. All rights reserved.
//

#import "MAXPagingScrollView.h"
#import "MAXPageControl.h"

@interface MAXPagingScrollView () <UIScrollViewDelegate> {
    
    NSMutableArray *_pageViews;
    NumItemsBlock _numItemsBlock;
    ViewInjectionBlockWithIndex _viewInjectionBlock;
    void (^_newPageBlock)(NSInteger newPage);
    UIPanGestureRecognizer *_consumePanGestureRecognizer;
    
}

@end

@implementation MAXPagingScrollView

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _pageControl = [[MAXPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 22, CGRectGetWidth(frame), 22)];
        [self addSubview:_pageControl];
        
        _currentPage = 0;
        
        _numPages = 0;
        _pageViews = [NSMutableArray array];
        
        _numItemsBlock = nil;
        _viewInjectionBlock = nil;
        
        _maxDelegate = nil;
        
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame: frame];
    
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _pageControl.frame = CGRectMake(0, CGRectGetHeight(frame) - 22, CGRectGetWidth(frame), 22);
    
}

#pragma mark - Reload Methods

-(void)reloadDataBlocks {
    if (_numItemsBlock != nil && _viewInjectionBlock != nil) {
        
        _numPages = _numItemsBlock();
        _pageControl.numberOfPages = _numPages;
        
        [self p_removeOldPageViewsWithPages: _pageViews];
        [self p_reloadPageViewsWithNumPages:_numPages];
        [self p_injectViewsWithNumPages:_numPages];
        
    }
}

-(void)reloadDataDelegate {
    
    if (self.maxDelegate != nil && [self.maxDelegate respondsToSelector:@selector(MAXScrollViewNumPages:)] == YES && [self.maxDelegate respondsToSelector:@selector(MAXScrollView:view:atIndex:)] == YES) {
        
        _numPages = [self.maxDelegate MAXScrollViewNumPages:self];

        [self p_removeOldPageViewsWithPages: _pageViews];
        [self p_reloadPageViewsWithNumPages:_numPages];
        [self p_injectViewsWithNumPages:_numPages];
        
    }
    
}

#pragma mark - Disabling Drag

-(void)setDisableDrag:(BOOL)disableDrag {
    _disableDrag = disableDrag;
    
    if (_disableDrag == YES) {
        _consumePanGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        [self.scrollView addGestureRecognizer: _consumePanGestureRecognizer];
    }
    else if(_consumePanGestureRecognizer != nil) {
        [self.scrollView removeGestureRecognizer: _consumePanGestureRecognizer];
    }
    
}



#pragma mark - Moving to new page

-(void)setPage:(NSInteger)thePage animated:(BOOL)isAnimated withCompletion:(void (^)(void))block {
    [block copy];
    
    if (_currentPage != thePage && thePage < _numPages) {
        if (isAnimated == YES) {
            __weak typeof(self) wSelf = self;
            [UIView animateWithDuration:0.3 animations:^{
                [wSelf p_moveScrollViewToPage:thePage];
            } completion:^(BOOL finished) {
                if (finished && block != nil) {
                    block();
                }
            }];
        }
        else {
            [self p_moveScrollViewToPage:thePage];
            if (block != nil) {
                block();
            }
        }
    }
    else if(_currentPage == thePage && block != nil) {
        block();
    }
    
}

-(void)p_moveScrollViewToPage:(NSInteger)thePage {
    self.scrollView.contentOffset = CGPointMake(thePage * CGRectGetWidth(self.frame), 0);
    _currentPage = thePage;
}

#pragma mark - Block methods

-(void)MAXScrollViewNumPagesWithBlock:(NumItemsBlock)block {
    _numItemsBlock = [block copy];
    if (_viewInjectionBlock != nil) {
        [self reloadDataBlocks];
    }
}

-(void)MAXScrollViewWithViewAtPageBlock:(ViewInjectionBlockWithIndex)block {
    _viewInjectionBlock = [block copy];
    if (_numItemsBlock != nil) {
        [self reloadDataBlocks];
    }
}

-(void)MAXScrollViewDidChangePage:(void (^)(NSInteger))block {
    _newPageBlock = [block copy];
}

#pragma mark - Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (_currentPage != page) {
        
        _currentPage = page;
        _pageControl.currentPage = page;
        
        if (_newPageBlock != nil) {
            _newPageBlock(page);
        }
        
    }
    
    if (_didScroll != nil) {
        _didScroll(scrollView.contentOffset);
    }
    
}

#pragma mark - Helpers

-(void)p_injectViewsWithNumPages:(NSInteger)theNumPages {
    
    for (int i = 0; i < theNumPages; i++) {
        
        UIView *view = [_pageViews objectAtIndex:i];
        
        if (_viewInjectionBlock != nil) {
            _viewInjectionBlock(view, i);
        }
        
        if (self.maxDelegate != nil &&[self.maxDelegate respondsToSelector:@selector(MAXScrollView:view:atIndex:)]) {
            [self.maxDelegate MAXScrollView:self view:view atIndex:i];
        }
        
    }
}

-(void)p_reloadPageViewsWithNumPages:(NSInteger)theNumPages {
    
    _pageViews = [NSMutableArray array];
    
    for (int i = 0; i < theNumPages; i++) {
        
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(self.frame), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [_scrollView addSubview:pageView];
        [_pageViews addObject:pageView];
    }
    
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame) * theNumPages, CGRectGetHeight(self.frame))];
    
}

-(void)p_removeOldPageViewsWithPages:(NSArray <UIView *> *)theViews {
    
    for (UIView *view in theViews) {
        
        [view removeFromSuperview];
        
    }
    
}

@end
