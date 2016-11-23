//
//  MAXSelectedContentButton.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 12/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXSelectedContentButton.h"

@interface MAXSelectedContentButton ()

@property (nonatomic, strong) NSMutableArray *selectedContent;

@end

@implementation MAXSelectedContentButton

-(id)init {
    if (self = [super init]) {
        [self p_setupSelectedContentButton];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setupSelectedContentButton];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupSelectedContentButton];
    }
    
    return self;
}

#pragma mark - Private Initializer

-(void)p_setupSelectedContentButton {
    
    _selectedContent = [NSMutableArray array];
    
    _contentFadeInTime = 0.2;
    _contentFadeOutTime = 0.2;
    
}

#pragma mark - Setters

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected == NO) {
        [self p_animateSelectedContentOut];
    }
    else {
        [self p_animateSelectedContentIn];
    }
    
}

-(void)addSelectedContent:(UIView *)theSelectedContent {
    
    if (self.isSelected == YES) {
        theSelectedContent.alpha = 1.0;
        theSelectedContent.hidden = NO;
    }
    else {
        theSelectedContent.alpha = 0.0;
        theSelectedContent.hidden = NO;
    }
    
    [self addSubview:theSelectedContent];
    
    [_selectedContent addObject:theSelectedContent];
    
}

-(void)removeSelectedContent:(UIView *)theSelectedContent {
    
    [_selectedContent removeObject:theSelectedContent];
    [theSelectedContent removeFromSuperview];
    
}

#pragma mark - Private Methods

-(void)p_animateSelectedContentIn {
    
    [UIView animateWithDuration:_contentFadeInTime animations:^{
        
        for (UIView *currentView in _selectedContent) {
            currentView.alpha = 1.0;
        }
        
    }];
    
}

-(void)p_animateSelectedContentOut {
    
    [UIView animateWithDuration:_contentFadeOutTime animations:^{
        
        for (UIView *currentView in _selectedContent) {
            currentView.alpha = 0.0;
        }
        
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
