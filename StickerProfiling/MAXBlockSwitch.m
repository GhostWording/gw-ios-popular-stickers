//
//  MAXBlockSwitch.m
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 02/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "MAXBlockSwitch.h"

@interface MAXBlockSwitch () {
    void (^_MAXValueChangedBlock)(void);
}

@end

@implementation MAXBlockSwitch

-(id)init {
    
    if (self = [super init]) {
        [self p_setupMAXBlockSwtich];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self p_setupMAXBlockSwtich];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self p_setupMAXBlockSwtich];
    }
    
    return self;
}

-(void)switchValueChangedWithCompletion:(void (^)(void))completion {
    _MAXValueChangedBlock = [completion copy];
}

-(void)p_setupMAXBlockSwtich {
    [self addTarget:self action:@selector(p_switchValueChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)p_switchValueChanged {
    if (_MAXValueChangedBlock != nil) {
        _MAXValueChangedBlock();
    }
}

@end
