//
//  GWTextFilter.m
//  WhatsAppMessageComposer
//
//  Created by Mathieu Skulason on 23/04/16.
//  Copyright © 2016 Konta ehf. All rights reserved.
//

#import "GWTextFilter.h"
#import "GWTag.h"

@interface GWTextFilter () {
    GWRecipient *_recipient;
}

@end

@implementation GWTextFilter

+(instancetype)filterWithRecipient:(GWRecipient *)theRecipient {
    
    GWTextFilter *filter = [[GWTextFilter alloc] init];
    [filter setRecipient:theRecipient];
    
    return filter;
}

-(id)init {
    if (self = [super init]) {
        _recipient = nil;
    }
    
    return self;
}

-(void)setRecipient:(GWRecipient *)theRecipient {
    
    _recipient = theRecipient;
    
    _tagIds = @[theRecipient.recipientId];
    _recipientGender = theRecipient.gender;
    _politeForm = theRecipient.politeForm;
}


-(NSArray <GWText *> *)filterTexts:(NSArray<GWText *> *)theTexts {

    NSMutableArray *array = [NSMutableArray array];
    
    for (GWText *text in theTexts) {
        if ([self isTextCompatible:text] == YES) {
            [array addObject:text];
        }
    }
    
    return array;
}

#pragma mark - 

-(BOOL)isTextCompatible:(GWText *)theText {

    if ([self p_tuOuVousCompatible:theText.politeForm andFilter:_politeForm] == NO && _politeForm != nil) {
        return NO;
    }
    
    if ([self p_genderCompatible:theText.target andFilter:_recipientGender] == NO && _recipientGender != nil) {
        return NO;
    }
    
    if ([self p_senderCompatible:theText.sender andFilter:_senderGender] == NO && _senderGender != nil) {
        return NO;
    }
    
    if ([self p_tagsString:theText.tagsString containsTagIds:_tagIds] == NO && _tagIds != nil && _tagIds.count != 0) {
        return NO;
    }
    
    if ([self p_basicCompatibleText:theText.intentionId comparisonText:_intentionId] == NO && _intentionId != nil) {
        return NO;
    }
    
    if ([self p_basicCompatibleText:theText.culture comparisonText:_culture] == NO && _culture != nil) {
        return NO;
    }
    
    return YES;
    
}

#pragma mark - Private filtering functions

-(BOOL)p_basicCompatibleText:(NSString *)theText comparisonText:(NSString *)theComparisonText {
    return [theText isEqualToString:theComparisonText] == YES;
}

-(BOOL)p_compatible:(NSString *)textValue andFilter:(NSString *)filterValue {
    
    if ([textValue isEqualToString:filterValue] == YES || [textValue isEqualToString:@"I"] == YES) {
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL)p_genderCompatible:(NSString *)textValue andFilter:(nullable NSString *)filterValue {
    
    if ([self p_compatible:textValue andFilter:filterValue] == YES || ([textValue isEqualToString:@"P"] == NO && [filterValue isEqualToString:@"N"] == YES) || ([textValue isEqualToString:@"N"] == YES && [filterValue isEqualToString:@"P"] == NO) ) {
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL)p_senderCompatible:(NSString *)textValue andFilter:(NSString *)filterValue {
    
    if ([textValue isEqualToString:@""] == YES || [filterValue isEqualToString:@""] == YES) {
        
        return NO;
    }
    
    if ([textValue isEqualToString:@"P"] == YES || [self p_genderCompatible:textValue andFilter:filterValue] == YES) {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)p_tuOuVousCompatible:(NSString *)textValue andFilter:(NSString *)filterValue {
    
    return ([self p_compatible:textValue andFilter:filterValue] == YES || ([textValue isEqualToString:@"P"] == YES && [filterValue isEqualToString:@"V"] == YES));
}

-(BOOL)p_tagsString:(NSString *)theTagsString containsTagIds:(NSArray <NSString *> *)theTagIds {
    
    if (theTagIds.count == 0) {
        return YES;
    }
    
    for (NSString *currentTag in theTagIds) {
        if ([self p_tagsString:theTagsString matchesTagId:currentTag] == NO) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)p_tagsString:(NSString *)tagsString matchesTagId:(NSString *)theTagId {
    
    if (tagsString == nil || theTagId == nil) {
        return NO;
    }
    
    if ([tagsString rangeOfString:theTagId].location != NSNotFound) {
        return YES;
    }
    
    return NO;
}


@end
