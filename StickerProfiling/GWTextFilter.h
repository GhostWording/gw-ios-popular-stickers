//
//  GWTextFilter.h
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 23/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GWRecipient.h"
#import "GWText.h"

NS_ASSUME_NONNULL_BEGIN

@interface GWTextFilter : NSObject

+(instancetype)filterWithRecipient:(GWRecipient *)theRecipient;

-(NSArray <GWText *> *)filterTexts:(NSArray <GWText *> *)theTexts;

@property (nullable, nonatomic, strong) NSArray <NSString *> *tagIds;
@property (nullable, nonatomic, strong) NSString *politeForm;
@property (nullable, nonatomic, strong) NSString *recipientGender;
@property (nullable, nonatomic, strong) NSString *senderGender;
@property (nullable, nonatomic, strong) NSString *intentionId;
@property (nullable, nonatomic, strong) NSString *culture;

-(void)setRecipient:(GWRecipient *)theRecipient;

@end

NS_ASSUME_NONNULL_END