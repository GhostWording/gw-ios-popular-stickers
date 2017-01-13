//
//  BlocksAlertController.m
//  StickerProfiling
//
//  Created by Mathieu Grettir Skulason on 1/13/17.
//  Copyright © 2017 Konta. All rights reserved.
//

#import "BlocksAlertController.h"

@interface BlocksAlertController () 

@end

@implementation BlocksAlertController

+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle actions:(NSArray<UIAlertAction *> *)actions {
    
    BlocksAlertController *controller = [self alertControllerWithTitle: title message: message preferredStyle: preferredStyle];
    
    for (UIAlertAction *currentAction in actions) {
        
        [controller addAction: currentAction];
        
    }
    
    return controller;
}

+(instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle firstActionTitle:(NSString *)firstActionTitle secondActionTitle:(NSString *)secondActionTitle thirdActionTitle:(NSString *)thirdActionTitle fourthActionTitle:(NSString *)fourthActionTitle completion:(void (^)(BlockAlertIndex))completion {
    [completion copy];
    
    
    BlocksAlertController *controller = [self alertControllerWithTitle: title message: message preferredStyle: preferredStyle];
    
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle: firstActionTitle style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
        
        completion( BlockAlertFirstIndex );
        
    }];
    
    [controller addAction: firstAction];
    
    if (secondActionTitle != nil) {
        
        UIAlertAction *secondAction = [UIAlertAction actionWithTitle: title style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
            
            completion( BlockAlertSecondIndex );
            
        }];
        
        [controller addAction: secondAction];
        
    }
    
    if (thirdActionTitle != nil) {
        
        UIAlertAction *thirdAction = [UIAlertAction actionWithTitle: title style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
            
            completion( BlockAlertThirdIndex );
            
        }];
        
        [controller addAction: thirdAction];
    }
    
    if (fourthActionTitle != nil) {
        
        UIAlertAction *fourthAction = [UIAlertAction actionWithTitle: title style: UIAlertActionStyleDefault handler: ^(UIAlertAction *action) {
            
            completion( BlockAlertFourthIndex );
            
        }];
        
        [controller addAction: fourthAction];
    }
    
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
