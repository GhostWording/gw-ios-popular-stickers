//
//  MAXFadeBlockButton.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 09/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXFadeBlockButton.h"

@interface MAXFadeBlockButton ()

@property (nonatomic, weak) MAXFadeBlockButton *wSelf;

@end

@implementation MAXFadeBlockButton

-(id)init {
    if (self = [super init]) {
        [self p_setupFadeButton];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setupFadeButton];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self p_setupFadeButton];
    }
    
    return self;
}

-(void)p_setupFadeButton {
    
    
    _wSelf = self;
    self.fadeAnimationTime = 0.2;
    self.fadeAlphaValue = 0.7;
    
    [self buttonTouchDownWithCompletion:^{
        [UIView animateWithDuration:self.fadeAnimationTime animations:^{
            _wSelf.alpha = self.fadeAlphaValue;
        }];
        
    }];
    
    [self buttonTouchUpInsideWithCompletion:^{
        [UIView animateWithDuration:self.fadeAnimationTime animations:^{
            _wSelf.alpha = 1.0;
        }];
    }];
    
    [self buttonTouchUpOutsideWithCompletion:^{
        [UIView animateWithDuration:self.fadeAnimationTime animations:^{
            _wSelf.alpha = 1.0;
        }];
    }];
    
    [self buttonTouchDragExitWithCompletion:^{
        [UIView animateWithDuration:self.fadeAnimationTime animations:^{
            _wSelf.alpha = 1.0;
        }];
    }];
    
    [self buttonTouchCancelWithCompletion:^{
        [UIView animateWithDuration:self.fadeAnimationTime animations:^{
            _wSelf.alpha = 1.0;
        }];
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
