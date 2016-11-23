//
//  MAXBlockSwitch.h
//  ReusableComponentsApp
//
//  Created by Mathieu Skulason on 02/05/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAXBlockSwitch : UISwitch

-(void)switchValueChangedWithCompletion:(void (^)(void))completion;

@end
