//
//  GWPersonalityQuestion.m
//  
//
//  Created by Mathieu Grettir Skulason on 11/23/16.
//
//

#import "GWPersonalityQuestion.h"
#import "GWCoreDataManager.h"

@implementation GWPersonalityQuestion

// Insert code here to add functionality to your managed object subclass
+(GWPersonalityQuestion *)createGWPersonalityQuestionOnMainThread {
    
    GWPersonalityQuestion *personalityQuestion = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([GWPersonalityQuestion class]) inManagedObjectContext: [[GWCoreDataManager sharedInstance] mainObjectContext] ];
    
    return personalityQuestion;
}

+(GWPersonalityQuestion *)createGWPersonalityQuestion {
    
    GWPersonalityQuestion *personalityQuestion = [NSEntityDescription insertNewObjectForEntityForName: NSStringFromClass([GWPersonalityQuestion class]) inManagedObjectContext: [[GWCoreDataManager sharedInstance] mainObjectContext] ];
    
    return personalityQuestion;
}

-(void)updateWithJsonDict:(NSDictionary *)theJsonDict {
    
    [MNFJsonAdapter refreshObject: self withJsonDict: theJsonDict option: kMNFAdapterOptionFirstLetterUppercase error:nil];
    
}
-(NSDictionary *)jsonKeysMapToProperties {
    
    return @{ @"personalityQuestionId" : @"Id" };
}

-(NSDictionary *)propertyKeysMapToJson {
    
    return @{ @"personalityQuestionId" : @"Id" };
}

#pragma mark - Getters

-(NSString *)questionWithCulture:(NSString *)theCulture {
    
    for (NSDictionary *question in self.question) {
        NSString *questionCulture = [question objectForKey: @"Language"];
        if ([questionCulture isEqualToString: theCulture] == YES) {
            
            NSString *questionString = [question objectForKey: @"Label"];
            return questionString;
        }
    }
    
    return nil;
}

-(NSUInteger)numAnswers {
    
    return self.answers.count;
}

-(NSString *)answerWithCulture:(NSString *)theCulture atIndex:(NSInteger)index completion:(void (^)(NSString * _Nullable answer, NSString * _Nullable answerId))completion {
    
    if (index < self.answers.count) {
        
        NSDictionary *currentAnswer = [self.answers objectAtIndex: index];
        
        NSString *answerId = [currentAnswer objectForKey: @"Id"];
        NSArray *labels = [currentAnswer objectForKey:@"Labels"];
        
        for (NSDictionary *currentLanguage in labels) {
            
            NSString *answerCulture = [currentLanguage objectForKey:@"Language"];
            if ([answerCulture isEqualToString: theCulture]) {
                
                NSString *answer = [currentLanguage objectForKey:@"Label"];
                
                if (completion != nil) {
                    completion(answer, answerId);
                }
                
                return answer;
                
            }
            
        }
        
    }
    
    if (completion != nil) {
        completion(nil, nil);
    }
    
    return nil;
}

@end
