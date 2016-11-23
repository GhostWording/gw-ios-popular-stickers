//
//  MENIGAScrollView.h
//  bank42
//
//  Created by Mathieu Grettir Skulason on 2/22/16.
//  Copyright © 2016 Meniga. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MAXPagingScrollView;
@class MAXPageControl;

NS_ASSUME_NONNULL_BEGIN

@protocol MAXScrollViewDelegateAndDataSource <NSObject>

@optional
-(NSInteger)MAXScrollViewNumPages:(MAXPagingScrollView*)theScrollView;
-(void)MAXScrollView:(MAXPagingScrollView*)theScrollView view:(UIView*)theView atIndex:(NSInteger)theIndex;

@end


typedef NSInteger (^NumItemsBlock)(void);
typedef void (^ViewInjectionBlockWithIndex)(UIView *theView, NSInteger thePage);

/** @discussion This class asks for the number of pages for the paged scroll view and allows you to add UI components to the view by injecting them into the block or delegate method. This class offers two ways to handle the data source, either by delegation or by using blocks depending on the user of the class. */
@interface MAXPagingScrollView : UIView

@property (nonatomic, strong) id <MAXScrollViewDelegateAndDataSource> maxDelegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) NSInteger numPages;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) MAXPageControl *pageControl;
@property (nonatomic, nullable) void (^didScroll)(CGPoint contentOffset);
@property (nonatomic) BOOL disableDrag;

/** @discussion This method is used to change the page of the scroll view. The page numbers are zero indexed and nothing happens if you try and move to a page that does not exist.
 
    @param thePage is zero indexed.
 */
-(void)setPage:(NSInteger)thePage animated:(BOOL)isAnimated withCompletion:(nullable void (^)(void))block;

/** @discussion This method is used to fetch the number of pages in the scroll view. It only ever stores one instance of the block so it shouldn't be used multiple times.
        
    @param block returns the number of pages in the scroll view.
        
    @return The return value comes from the block parameter.
 
    @code [myScrollView MENIGAScrollViewNumPagesWithBlock:^{
    // makes the scroll view create 10 pages.
    return 10;
 }];
 */
-(void)MAXScrollViewNumPagesWithBlock:(nonnull NumItemsBlock)block;


/** @discussion This method injects the view and its page to the user via a block. This way the user can add what he needs to the view without having to worry about positioning and creating a custom scroll view. By injecting it with the page we can add custom labels and data to it easily. Example below:
 
    @param block injects the view for the current page.
 
    @code [myScrollView MENIGAScrollViewWithViewAtPageBlock:^(UIView *theView, NSInteger thePage){
    if(thePage == 0) {
        theView.backgroundColor = [UIColor redColor];
    }
    else {
        theView.backgroundColor = [UIColor orangeColor];
    }
 }];
 */
-(void)MAXScrollViewWithViewAtPageBlock:(nonnull ViewInjectionBlockWithIndex)block;

/** @discussion This method is fired when the scroll view did scroll delegate checks if we are more on a new page than the one we were on.
        
    @param block returns the page the user is currently on.
 
 */
-(void)MAXScrollViewDidChangePage:(nonnull void (^)(NSInteger newPage))block;

/** @discsussion This method reloads the data using the block methods if they have been used. If blocks have not been registered nothing happens as we cannot determine the number of pages and we cannot inject the views to the user using the blocks. 
 */
-(void)reloadDataBlocks;

/** @discussion This method is used to fetch and reload the data using the delegate. If the receiver does not respond to the necessary delegates nothing will happen.
 
 */
-(void)reloadDataDelegate;



@end

NS_ASSUME_NONNULL_END
